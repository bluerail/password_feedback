require 'rails'

require 'inputs/password_confirmation_input.rb'
require 'inputs/password_strength_input.rb'
#require 'controllers/password_feedback_controller.rb'

I18n.load_path += Dir["#{File.dirname(__FILE__)}/../config/locales/*.yml"]
module PasswordFeedback
  class Engine < ::Rails::Engine
  end
end
