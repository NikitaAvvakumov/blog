class Post < ActiveRecord::Base

  belongs_to :user
  belongs_to :topic
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true
  #validates :topic_id, presence: true
  default_scope -> { order('created_at DESC') }

  def to_param
    "#{id}-#{title.parameterize}"
  end
end
