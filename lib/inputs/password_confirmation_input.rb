require 'formtastic'
require 'formtastic-bootstrap'

class PasswordConfirmationInput < Formtastic::Inputs::PasswordInput
  include FormtasticBootstrap::Inputs::Base

  def to_html
    bootstrap_wrapping do
      builder.password_field(method, form_control_input_html_options)
    end
  end
end
