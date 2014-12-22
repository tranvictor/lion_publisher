require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminShowComment
end

module RailsAdmin
  module Config
    module Actions
      class ShowInAppComment < RailsAdmin::Config::Actions::Base
        # There are several options that you can set here.
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.

        register_instance_option :member do
          true
        end

        register_instance_option :http_methods do
          [:get]
        end

        register_instance_option :controller do
          Proc.new do
            redirect_to main_app.upload_image_path(@object.upload_image)
          end
        end

        register_instance_option :link_icon do
          'icon-eye-open'
        end
      end
    end
  end
end
