require 'formtastic'
require 'formtastic-bootstrap'

class PasswordStrengthInput < Formtastic::Inputs::PasswordInput
  include FormtasticBootstrap::Inputs::Base

  def to_html
    bootstrap_wrapping do
      builder.password_field(method, form_control_input_html_options) +
        template.content_tag('div', class: 'password-feedback') do
          template.content_tag('div', '', class: 'password-feedback-bar') do
            template.content_tag('span', '', class: 'password-feedback-indicator') +
              template.content_tag('span', '', class: 'password-feedback-indicator') +
              template.content_tag('span', '', class: 'password-feedback-indicator')
          end +
          template.content_tag('span', class: 'password-feedback-help', 'data-toggle' => 'popover', title: _('Password help')) do
            '?'
          end
      end
    end
  end
end
