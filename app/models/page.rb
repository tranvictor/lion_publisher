require "open-uri"

class Page < ActiveRecord::Base
  attr_accessible :article_id, :body, :citation, :image,
                  :page_no, :title, :broken

  searchable(only_reindex_attribute_changes_of: [:body]) do
    text :body
  end

  has_attached_file :image,
    :styles => { :medium => "1136x500>",
                 :thumb => "140x140>" },
    :processors => [:thumbnail, :compression],
    :default_url => "/images/:style/missing.png"

  belongs_to :article
  validates_attachment_content_type(
    :image,
    :content_type => /^image\/(png|gif|jpeg|jpg)/,
    message: 'must be a gif, jpg or png image.')

  validates :article_id, :page_no, presence: true
  validates :page_no, numericality: {
                        only_intger: true, greater_than_or_equal_to: 1,
                        message: 'must be a positive integer'}

  def short_citation
    require 'uri'
    begin
      if self.citation.nil?
        "#"
      else
        u = URI.parse(self.citation)
        if u.nil?
          "#"
        else
          u.host
        end
      end
    rescue Exception
    end
  end

  def thumbnail
    self.image.url(:medium)
  end

  def hi_thumbnail
    self.image.url(:original)
  end

  def url_with_protocol(url)
   /^http/.match(url) ? url : "http://#{url}"
  end

  def full_citation
    url_with_protocol(self.citation)
  end

  def bodys
    self.body != nil ? self.body.split(/\n/) : []
  end

  def desc
    if self.body and self.body.length > 136
      self.body[0..136] + '...'
    else
      self.body || 'Default page body'
    end
  end
end
