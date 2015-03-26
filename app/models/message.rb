class Message < ActiveRecord::Base
  # attr_accessible :body, :email, :ip, :name, :state, :title, :user_id

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 4000, too_long: "4000 characters is the maximum allowed" }
  belongs_to :user

  def desc
    if self.body and self.body.length > 55
      self.body[0..55] + '...'
    else
      self.body || 'Default page body'
    end
  end
end
