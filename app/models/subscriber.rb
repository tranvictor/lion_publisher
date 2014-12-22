class Subscriber < ActiveRecord::Base
  before_validation :generate_token
  attr_accessible :email, :token

  validates_presence_of :email, message: 'Email field should not be blank.'
  validates_uniqueness_of :email, message: 'This email already subscribed.'
  validates_presence_of :token
  validates_uniqueness_of :token

  private
  def generate_token
    return if self.token != nil
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Subscriber.exists?(token: random_token)
    end
  end
end
