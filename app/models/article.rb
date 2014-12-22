require 'action_view'
include ActionView::Helpers::NumberHelper

class Article < ActiveRecord::Base
  attr_accessible :title, :page_ids, :category_id, :published, :publish_date,
    :intro, :outtro, :cache_thumbnail, :cache_desc, :cache_citation, :is_list

  searchable(only_reindex_attribute_changes_of: [:title]) do
    text :title
    #text :pages_body do
    #  pages.map { |page| page.body }
    #end
  end

  has_many :pages, :dependent => :destroy
  validates :title, :presence => true
  validates :title, :uniqueness => true
  belongs_to :category
  belongs_to :user

  self.per_page = 30

  def author
    self.user
  end

  def intros
    self.intro != nil ? self.intro.split(/\n/) : []
  end

  def outtros
    self.outtro != nil ? self.outtro.split(/\n/) : []
  end

  def sorted_pages
    self.pages.order(:page_no)
  end

  def pageview_to_human
    number_to_human(self.total_pageview,
                    :format => '%n%u',
                    :units => {:million => 'M',
                    :thousand => 'K',
                    :unit => '',
                    :billion => 'B'})
  end

  [:thumbnail, :hi_thumbnail, :desc, :citation].each do |attr|
    self.class_eval %{
      def update_#{attr}
        page = self.pages.order('page_no').first
        self.cache_#{attr} = (page.#{attr} rescue "")
        self.save
      end

      def #{attr}
        if self.cache_#{attr}.nil? || self.cache_#{attr} == ''
          self.update_#{attr}
        end
        self.cache_#{attr}
      end
    }
  end

  def update_all
    [:thumbnail, :hi_thumbnail, :desc, :citation].each do |attr|
      self.send("update_#{attr}")
    end
    self.pages.order('page_no').each_with_index do |page, index|
      page.update_attributes(page_no: index + 1) if page.page_no != index + 1
    end
  end

  def self.trending
    today = Date.current.to_time.to_i / 86400
    last_7_days_attrs = (0..6).collect { |i| "articles.p#{(today - i) % 8}" }
    self.select([:id, :title, :cache_hi_thumbnail, :category_id,
                 "(#{last_7_days_attrs.join('+')}) AS pv"])
        .where(:published => true)
        .order("pv DESC")
        .limit(6)
  end

end
