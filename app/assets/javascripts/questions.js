$(document).ready(function() {
  if ($('#show_question').length) {

  var $question = $('.question');

  // Make the text size oomph
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
});