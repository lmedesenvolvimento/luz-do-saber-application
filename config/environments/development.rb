Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
  # config.webpacker.check_yarn_integrity = false
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {}
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.active_storage.service = :local

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :file
  config.action_mailer.perform_caching = false

  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  config.active_support.deprecation = :log

  config.assets.debug = false
  config.assets.quiet = true

  config.action_view.raise_on_missing_translations = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_mailer.default_url_options = { host: ENV.fetch("APPLICATION_HOST") }
  config.action_mailer.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))

  config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
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
