# RailsAdmin config file. Generated on July 13, 2013 12:54
# See github.com/sferik/rails_admin for more informations
require Rails.root.join('lib', 'rails_admin_create_article.rb')
require Rails.root.join('lib', 'rails_admin_edit_article.rb')
RailsAdmin.config do |config|


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Magazine', 'Admin']

  module RailsAdmin
    module Config
      module Actions
        class CreateArticle < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end
        class EditArticle < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
        end
      end
    end
  end
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated

  config.authorize_with :cancan

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['Article', 'Impression', 'Page', 'User']

  # Include specific models (exclude the others):
  config.included_models = ['Article', 'User', 'Category',
                            'Subscriber'
                            # disable user posts
                            #'UploadImage',
                            ]

  config.navigation_static_label = "Admin tools"

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:

  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions
    index do
      except [Advertise]
    end
    new do
      only [User, Category]
    end
    export
    # history_index
    bulk_delete
    # member actions
    show
    edit do
      only [User, Category]
    end
    delete do
      except [Advertise]
    end

    # history_show
    create_article do
      visible do
        bindings[:abstract_model].model.to_s == "Article"
      end
    end

    edit_article do
      visible do
        bindings[:abstract_model].model.to_s == "Article"
      end
    end
  end

  ###  User  ###

  config.model 'User' do

    # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

    # Found associations:



    # Found columns:

      configure :id, :integer
      configure :email, :string
      configure :confirmation_token, :string
      configure :confirmed_at, :datetime
      configure :confirmation_sent_at, :datetime
      configure :unconfirmed_email, :string
      configure :user_name, :string

    # Cross-section configuration:

      # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
      # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
      # label_plural 'My models'      # Same, plural
      # weight 0                      # Navigation priority. Bigger is higher.
      # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
      # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

    # Section specific configuration:

      list do
        field :id
        field :email
        field :confirmed_at
        field :user_name
        field :is_admin
        field :is_writer
      end
      show do
        field :id
        field :email
        field :is_admin
        field :is_writer
        field :user_name
        field :confirmed_at
      end
      edit do
        field :id
        field :email
        field :user_name
        field :is_admin
        field :is_writer
        field :password
      end
      export do; end
      # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
      # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
      # using `field` instead of `configure` will exclude all other fields and force the ordering
  end

  # disable user posts
  #config.model 'UploadImage' do
  #  list do
  #    field :id
  #    field :title
  #    field :impressions_count
  #    field :image_url
  #  end
  #  show do; end
  #  edit do; end
  #  export do; end
  #end
end
