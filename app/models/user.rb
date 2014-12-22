class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable, :rememberable,
         :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name,
                  :user_name, :confirmed_at, :avatar, :is_admin, :login, :is_writer,
                  :shorten_domain
  # attr_accessible :title, :body

  has_attached_file :avatar,
                    :styles => {:medium => "300x300>",
                                :thumb => "90x90",
                                :tiny_thumb => "35x35"},
                    :default_url => "/images/:attachment/noavatar_:style.jpg"
  has_shortened_urls
  validates :email, presence: true, uniqueness: true
  validates :user_name, presence: true, uniqueness: true
  validates_attachment_content_type :avatar,\
    :content_type => /^image\/(png|gif|jpeg|jpg)/,\
    message: 'must be a gif, jpg or png image.'

  has_many :upload_images, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :articles, dependent: :nullify
  has_many :messages
  has_one :publisher, dependent: :destroy

  def admin?
    is_admin || Settings.admin_emails.include?(email)
  end

  def super_admin?
    Settings.admin_emails.include?(email)
  end

  def writer?
    is_writer
  end

  def avatar_url
    Settings.host + avatar.url
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(user_name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def owner?(publisher)
    self.publisher && self.publisher.id == publisher.id
  end
end
