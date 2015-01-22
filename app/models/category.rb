class Category < ActiveRecord::Base
  # attr_accessible :name, :article_ids, :color, :parent_id, :subcategory_ids

  validates :name, :presence => true
  validates_uniqueness_of :name, scope: :parent_id
  has_many :articles
  has_many :subcategories, class_name: "Category",
    foreign_key: "parent_id"
  belongs_to :parent, class_name: "Category"

  scope :main_categories, -> { Category.where(parent_id: nil) }

  def self.category_tree
    all_categories = Category.order('parent_id ASC')
    result = {}
    all_categories.each do |cat|
      cat.parent_id ? (result[cat.parent_id] << cat) : (result[cat.id] = [cat])
    end
    result
  end

  after_save :clear_category_tree_cache
  after_destroy :clear_category_tree_cache

  private
  def clear_category_tree_cache
    action_controller = ActionController::Base.new
    action_controller.expire_fragment("category_tree")
    action_controller.expire_fragment("category_tree_actived_on_")
    Category.pluck(:id).each do |id|
      action_controller.expire_fragment("category_tree_actived_on_#{id}")
    end
    RedisConnectionPool.instance.with do |connection|
      connection.eval(
        "return redis.call('del', unpack(redis.call('keys', ARGV[1])))",
        argv: ["cache:views*"]
      ) rescue nil
    end
  end

end
