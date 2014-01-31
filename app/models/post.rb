class Post < ActiveRecord::Base

  validates :title, presence: true
  validates :body, presence: true
  default_scope -> { order('created_at DESC') }
end
