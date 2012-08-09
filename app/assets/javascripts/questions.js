$(document).ready(function() {

  // 1. Make the text size oomph.
  function oomph_question() {
    var l = $($question).text().length;

    if (l > 160) {
      $($question).css({'font-size': '16px'});
    } else if (l > 50 && l < 160) {
      $($question).css({'font-size': '20px'});
    } else {
      $($question).css({'font-size': '30px'});
    }

    var $inner = $('.inner', $question);

    var h = ($($question).height() - $($inner).height()) / 2;
    $($inner).css({'margin-top': h + 'px'});
  }



  // 2. Countdown situation
  var Countdown = function (settings)
  {
    // Variable
    var thisone = this;

    // Get the selector that will be replaced with countdown
    thisone.holder = $("#" + settings.holder_id);

    //  if there is no element with this id - do not apply plugin
    if (!thisone.holder[0]) return false;

    // We get the curent time
    var current_date = (new Date()).getTime();

    // constants
    var MAIN_SECTION_MARGIN_BOTTOM = 35,
      MAIN_SECTION2_PADDING = 20,
      COUNTDOWN_PADDING = 20,
      COUNTDOWN_TITLE_FONT_SIZE = 18;

    settings.start_work = current_date;
    settings.end_work = current_date + 12000;

    // number styles
    settings.color = "#62c114";
    settings.border_color = "#000";
    settings.color_opacity = 0.9;
    settings.border_color_width = 1;

    var width_height = Math.floor(545 * 160 / 730);

    countdown_margin = Math.floor(545 * 27 / 730),
    number_scale_x = (width_height / 160).toFixed(2) * 1,
    number_scale_y = (width_height / 160).toFixed(2) * 1;

    thisone.countdown_template = '' +
      '<div id="countdown_' + settings.holder_id + '" class="countdown clearfix">' +
        '<div class="time_block">' +
          '<div id="countdown_seconds_' + settings.holder_id + '" class="time_block_number"></div>' +
        '</div>' +
      '</div>'

      // function that returns object with dates difference
    thisone.dateDifference = function (start_works_date, end_works_date)
    {
      var difference = end_works_date - start_works_date;

      return (isNaN(difference) || difference <= 0) ? {s : 0, m : 0, h : 0, d : 0} : {
        s : Math.floor(difference / 1000 % 60),    // seconds
        m : Math.floor(difference / 60000 % 60),   // minutes
        h : Math.floor(difference / 3600000 % 24), // hours
        d : Math.floor(difference / 86400000)      // days
      }
    };

    thisone.getFormatedDate = function(current_date, end_works_date)
    {

      // get difference for current date and end working day
      var time_obj = thisone.dateDifference(current_date, end_works_date);

      time_obj.d = time_obj.d.toString();
      time_obj.h = time_obj.h.toString();
      time_obj.m = time_obj.m.toString();
      time_obj.s = time_obj.s.toString();

      for (var i in time_obj)
      {
        // if value of date item has one number - adding "0" before
        if (time_obj[i].length == 1) time_obj[i] = "0" + time_obj[i];

        // if value of date is negative set all date items to "00",
        // it means that the working date is expired
        if (time_obj[i][0] && time_obj[i][0] == "-") {
          var zeroD = "00";
          time_obj.d = time_obj.h = time_obj.m = time_obj.s = zeroD;

          break;
        }
      }

      return time_obj;
    }

    // init countdown
    thisone.Init = function(start_works_date, end_works_date)
    {
      // append html template for counter
      thisone.holder.append(thisone.countdown_template);


      // set svg/vml areas for date items
      // Raphael("the_id", width, height);
      var r = Raphael("countdown_seconds_" + settings.holder_id, width_height, width_height);

      // set default style for countdown numbers
      var style_object = {fill: settings.color, stroke:  settings.border_color, "fill-opacity":  settings.color_opacity, "stroke-width": settings.border_color_width, "stroke-linecap":"round", translation:"0 0"};

      var number1_x = 7;
      var number2_x = Math.round(width_height / 2 + 4);

      // scale each number and set default position
      var letter1 = r.path(helvetica["0"]).attr(style_object).scale(number_scale_x, number_scale_y, 0, 0).translate(number1_x, 1);
      var letter2 = r.path(helvetica["0"]).attr(style_object).scale(number_scale_x, number_scale_y, width_height / 2, 0).translate(number2_x, 1);

      // start 1-second interval
      var getCurrentTimeInterval = setInterval(function ()
      {

        if (stop_countdown) window.clearInterval(getCurrentTimeInterval); // stop the loop

        // get current date
        var current_date = new Date();

        var date_obj = thisone.getFormatedDate(current_date, end_works_date);

        // set animation of Seconds
        letter1.animate({path:helvetica[(date_obj.s).substr(0, 1)]}, 250);
        letter2.animate({path:helvetica[(date_obj.s).substr(1)]}, 250);

        if (date_obj.s == '06') {
          letter1.animate({fill: '#ffba00'}, 500);
          letter2.animate({fill: '#ffba00'}, 500);
        } else if (date_obj.s == '03') {
          letter1.animate({fill: '#FF0000'}, 500);
          letter2.animate({fill: '#FF0000'}, 500);
        } else if (date_obj.s == '00') {
          window.clearInterval(getCurrentTimeInterval); // stop the loop
          if (pinging()) show_next_question();
        }

      }, 1000);
    }

    return thisone.Init(settings.start_work, settings.end_work);
  };

  // 3. Queuing questions.
  function get_next_question() {
    $.get('/questions/next/', function(response) {

      if (response.question) {

        // First just reset everything, let's prevent problems
        var response_params = ['wearedone', 'question', 'slug', 'a1', 'a1id', 'a1votes', 'a2', 'a2id', 'a2votes', 'a3', 'a3id', 'a3votes', 'a4', 'a4id', 'a4votes'];
        $(response_params).each(function(index, value) {
          $question.attr('data-' + value, 'false');
        });

        $question.attr('data-question', response.question.question);
        $question.attr('data-slug', response.question.slug);
        var count = 1;
        $(response.question.answers).each(function(key, value) {
          var a = 'data-a' + count;
          var aid = 'data-a' + count + 'id';
          var av = 'data-a' + count + 'votes';

          $question.attr(a, value.answer);
          $question.attr(aid, value.id);
          $question.attr(av, (value.votes == null ? false : value.votes));

          count++;
        });

      } else {
        $question.attr('data-wearedone', 'true');
      }

    });
  }

  function show_next_question() {

    $('#timer #spinner').fadeOut();
    stop_countdown = false;

    if ($question.attr('data-wearedone') == 'true') { window.location.href = '/questions/ninja'; }

    var nextq = $question.attr('data-question');

    var nexts = $question.attr('data-slug');

    $('.inner', $question).fadeOut().text(nextq).fadeIn();
    oomph_question();
    $('#countdown_timer').fadeOut().remove();
    $($answers).fadeOut().empty();

    $('.result1').fadeOut();
    $('.result2').fadeOut();
    $('.result3').fadeOut();
    $('.result4').fadeOut();

    var count = 1;
    while (count <= 4) {
      var a = $($question).attr('data-a' + count);
      var aid = $($question).attr('data-a' + count + 'id');
      var av = $($question).attr('data-a' + count + 'votes');
      var klass = (count % 2 ? 'alpha' : 'omega');
      var answer_template = '<div class="grid_8 ' + klass +'"><div class="answer" data-votes="' + av + '"><a href="/questions/' + nexts + '/answers/' + aid + '/vote">' + a + '</a></div></div>';
      if (a && aid && a !== 'false' && aid !== 'false') {
        $(answer_template).appendTo($answers);
      }
      count++;
    }
    $($answers).fadeIn();
    new Countdown({holder_id : "timer"});
    $('#timer').fadeIn();
    get_next_question();
  }

  function calculate_votes() {
    var vote_total = 0;
    $('.answers .answer').each(function() {
      vote_total += parseInt( $(this).attr('data-votes') );
    });

    var vote1 = ( parseInt( $('.answer').eq(0).attr('data-votes') ) / vote_total) * 100;
    var vote2 = ( parseInt( $('.answer').eq(1).attr('data-votes') ) / vote_total) * 100;
    var vote3 = ( parseInt( $('.answer').eq(2).attr('data-votes') ) / vote_total) * 100;
    var vote4 = ( parseInt( $('.answer').eq(3).attr('data-votes') ) / vote_total) * 100;

    $('.result1 p').text(Math.round(vote1) + '%');
    $('.result2 p').text(Math.round(vote2) + '%');
    $('.result3 p').text(Math.round(vote3) + '%');
    $('.result4 p').text(Math.round(vote4) + '%');

    if (vote1 >= 0) $('.result1').fadeIn();
    if (vote2 >= 0) $('.result2').fadeIn();
    if (vote3 >= 0) $('.result3').fadeIn();
    if (vote4 >= 0) $('.result4').fadeIn();
  }

  function pinging() {
    if ($($question).attr('data-pinging') == 'true') {
      return true;
    } else {
      return false;
    }
  }


  if ($('#show_question').length) {

    var $question = $('.question');
    var $answers = $('.answers');
    var stop_countdown = false;

    // Start the first question
    oomph_question();
    new Countdown({holder_id : "timer"});
    if (pinging()) {
      get_next_question();
    }

    $('.answer a').live('click', function(e) {

      e.preventDefault();

      stop_countdown = true;
      $('#countdown_timer').fadeOut().remove();

      if (pinging()) {
        $('#timer #spinner').fadeIn();
      }

      if ($($question).attr('data-logged-in') == 'false') {
        window.location.href = '/registration'
      }

      $.get($(this).attr('href'));

      var this_votes = parseInt( $(this).parent().attr('data-votes') );
      this_votes += 1;
      $(this).parent().attr('data-votes', this_votes);

      // calculate votes
      calculate_votes();

      if (pinging()) {
        setTimeout(function() { show_next_question() }, 3000);
      }
    });

    $('.skip_question').live('click', function(e) {
      e.preventDefault();

      stop_countdown = true;
      $('#countdown_timer').fadeOut().remove();
      $('#timer #spinner').fadeIn();

      setTimeout(function() { show_next_question() }, 1000);
    });

  }


  if ($('#show_question_nojs').length) {
    var $question = $('.question');
    var $answers = $('.answers');
    oomph_question();

    // calculate votes
    calculate_votes();
  }
});