class Topic < ActiveRecord::Base

  has_many :posts
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def to_param
    "#{id}-#{name.parameterize}"
  end
end
