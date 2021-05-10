require Rails.root.join("config/smtp")

Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
  # config.webpacker.check_yarn_integrity = false
  config.cache_classes = true
  config.eager_load = true

  # https://github.com/lautis/uglifier/issues/127
  # config.assets.js_compressor = :uglifier
  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.compile = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))
  config.active_storage.service = :local

  config.log_level = :debug
  config.log_tags = [ :request_id ]

  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS

  config.active_support.deprecation = :notify
  config.i18n.fallbacks = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.active_record.dump_schema_after_migration = false

  config.middleware.use Rack::CanonicalHost, ENV.fetch("APPLICATION_HOST")
  config.middleware.use Rack::Deflater
  config.action_mailer.default_url_options = { host: ENV.fetch("APPLICATION_HOST") }
  config.action_mailer.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))
  config.force_ssl = false
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=31557600",
  }

  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  if ENV.fetch("HEROKU_APP_NAME", "").include?("staging-pr-")
    ENV["APPLICATION_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
  end

  config.paperclip_defaults = {
      storage: :s3,
      s3_protocol: 'https',
      s3_permissions: 'public',
      s3_region: 'us-east-1',
      s3_credentials: {
        bucket: ENV['MINIO_BUCKET_NAME'],
        access_key_id: ENV['MINIO_ACCESS_KEY_ID'],
        secret_access_key: ENV['MINIO_SECRET_ACCESS_KEY'],
      },
      s3_host_name: ENV['MINIO_HOSTNAME'],
      s3_options: {
        endpoint: "https://#{ENV['MINIO_HOSTNAME']}",
        force_path_style: true
      }
    }
end
