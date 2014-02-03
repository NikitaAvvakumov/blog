class User < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :bio, presence: true
  has_secure_password
  validates :password, length: { minimum: 8 }

  before_save :downcase_email

  private

    def downcase_email
      self.email.downcase!
    end
end
