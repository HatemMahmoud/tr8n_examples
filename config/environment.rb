ENV['RAILS_ENV'] = 'development'

require "pp"

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.reload_plugins = true
  config.time_zone = 'UTC'

end
