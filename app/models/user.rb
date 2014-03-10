class User < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :bio, presence: true
  validates :title, presence: true
  has_secure_password
  validates :password, length: { minimum: 8 }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  default_scope -> { order('id ASC') }

  has_many :posts
  #has_attached_file :avatar, styles: { medium: '300x300', thumb: '100x100' }, default_url: 'missing1.png'
  has_attached_file :avatar,
                    storage: :dropbox,
                    dropbox_credentials: Rails.root.join('config/dropbox.yml'),
                    dropbox_options: {}
  #validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  before_save :downcase_email
  before_create :create_remember_token
  before_validation :create_slug

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def to_param
    slug
  end

  private

    def downcase_email
      self.email.downcase!
    end

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def create_slug
      self.slug = name.parameterize
    end
end
