class Topic < ActiveRecord::Base

  has_many :posts
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  #validates :name, format: { with: /(\ACode|\ADesign)/ }
end
