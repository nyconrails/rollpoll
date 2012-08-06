class Vote < ActiveRecord::Base

  belongs_to :user, :counter_cache => :votes_count
  belongs_to :answer, :counter_cache => :votes_count

  attr_accessible :answer_id, :user_id


end
