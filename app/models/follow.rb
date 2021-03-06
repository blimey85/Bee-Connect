class Follow < ActiveRecord::Base
  belongs_to :follower, foreign_key: 'follower_id', class_name: 'User', required: true
  belongs_to :following, foreign_key: 'following_id', class_name: 'User', required: true
end