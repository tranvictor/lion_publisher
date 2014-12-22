require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminCreateArticle
end

module RailsAdmin
  module Config
    module Actions
      class CreateArticle < RailsAdmin::Config::Actions::Base
        # There are several options that you can set here.
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          Proc.new do
            redirect_to main_app.new_article_url
          end
        end

        register_instance_option :link_icon do
          'icon-plus'
        end
      end
    end
  end
end