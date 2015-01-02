Magazine::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => 'trendsread',
      :access_key_id => 'AKIAIUWC6PGFDUH44BTQ',
      :secret_access_key => '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'
    },
    :url => ':s3_domain_url',
    :path =>':class/:attachment/:id_partition/:style/:filename',
    # comment above 2 lines and uncomment 3 following lines to enable cloudfront
    #:url => ':s3_alias_url',
    #:path =>':class/:attachment/:id_partition/:style/:filename',
    #:s3_host_alias => 'dsa1vij6e1s44.cloudfront.net'
  }
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  config.assets.initialize_on_precompile = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = false

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  config.action_mailer.default_url_options = { :host => 'trendsread.com' }
  config.action_mailer.smtp_settings = {
    :address => "smtp.mailgun.org",
    :port => 587,
    :authentication => 'plain',
    :user_name => 'news@sandbox69738.mailgun.org',
    :password => 'magazine1337'
  }

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :error

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :redis_store, 'redis://localhost:6379/0/cache'

  # Enable http redis caching
  # config.action_dispatch.rack_cache = {
  #   metastore:   'redis://localhost:6379/1/metastore',
  #   entitystore: 'redis://localhost:6379/1/entitystore'
  # }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += [ /\A[^\/\\]+\.(ccs|js)$/i ]

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  Encoding.default_external = Encoding::UTF_8

  Encoding.default_internal = Encoding::UTF_8

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.eager_load = true

end