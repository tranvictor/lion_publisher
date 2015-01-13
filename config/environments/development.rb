Magazine::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  #config.paperclip_defaults = {
  #  :storage => :s3,
  #  :s3_credentials => {
  #    :bucket => 'us.teensdigest',
  #    :access_key_id => 'AKIAIZP4ZU5MHXBQHIEA',
  #    :secret_access_key => '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'
  #  },
  #  #:url => ':s3_alias_url',
  #  #:path =>':class/:attachment/:id_partition/:style/:filename',
  #  #:s3_host_alias => 'dsa1vij6e1s44.cloudfront.net'
  #}

  Rails.application.routes.default_url_options = {:host => 'localhost:3000'}

  config.cache_classes = false
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  # config.cache_store = :redis_store, 'redis://localhost:6379/0/cache'

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Default url option for devise
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  # Send email in development mode?
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    address: "smtp.mailgun.org",
    port: 587,
    authentication: 'plain',
    user_name: 'news@sandbox69738.mailgun.org',
    password: 'magazine1337'
  }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.js_compressor = false

  # Expands the lines which load the assets
  config.assets.debug = true

end