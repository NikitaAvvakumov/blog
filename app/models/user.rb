class User < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :bio, presence: true
  has_secure_password
  validates :password, length: { minimum: 8 }

  before_save :downcase_email
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def downcase_email
      self.email.downcase!
    end

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
