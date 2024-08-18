require_relative "boot"

require "rails/all"
require 'sprockets/railtie'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TempestVideo
  class Application < Rails::Application
config.autoload_paths += %W(#{config.root}/config/routes)

##
# Make sure classy_enum enums get loaded
config.autoload_paths += %W(#{config.root}/app/enums)

##
# Set timezone for project
config.time_zone = 'Adelaide'

##
# Set encoding specifically for builds on Tempest Server
config.encoding = 'utf-8'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
