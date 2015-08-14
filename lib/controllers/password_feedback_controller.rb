class PasswordFeedbackController < ActionController::Base
  def password_score
    params[:email] = '' unless params[:email].present?
    score = ::Zxcvbn.test(params[:password].strip,
      [params[:email]] + params[:email].split(/[[:^word:]_]/)).score

    n, strength, message = if score == 4
                             [3, 'strong', _('This password is strong')]
                           elsif score >= User.min_password_score
                             [2, 'ok', _('This password is acceptable')]
                           else
                             [1, 'weak', _('This password is weak')]
                           end

    render inline: {
      strength: strength,
      message: message,
      n: n,
    }.to_json
  end
end
