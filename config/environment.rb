# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Rollpoll::Application.initialize!

APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")