class Comment < ActiveRecord::Base

  belongs_to :post
  validates :content, presence: true
  validates :post_id, presence: true
  validates :author, presence: true
  default_scope -> { order('created_at ASC') }
end
