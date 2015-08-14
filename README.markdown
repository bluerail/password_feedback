[![Gem Version](https://badge.fury.io/rb/password_feedback.svg)](http://badge.fury.io/rb/password_feedback)

Interactive password feedback.

- We include [zxcvbn.js](https://github.com/dropbox/zxcvbn).
- We can optionally also do a server-side check with [zxcvbn-ruby](https://rubygems.org/gems/zxcvbn-ruby).
- You can add a model validation with [devise_zxcvbn](https://rubygems.org/gems/devise_zxcvbn).

Usage
=====
Add to your `Gemfile`

    gem 'ajax_status'

Add to your `application.js`:

    // =require ajax_status

And to your `application.css`:

    /* =require ajax_status */

We assume that formtastic & formtastic-bootstrap are being used:

    semantic_form_form @user do |f|
      .col-md-6= f.input :password, as: :password_strength
      .col-md-6= f.input :password_confirmation, as: :password_confirmation

- By default, we only do a client-side check with `zxcvbn.js`.
- If the `zxcvbn-ruby` gem is installed, we also do a server-side check.
- The following settings are taken into account, if they're set:
  `Devise.config.password_length`, Devise.config.min_password_score` (used by
  `devise_zxcvbn`).
