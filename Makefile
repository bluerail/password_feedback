all:
	coffee -c lib/assets/javascripts/password_feedback.js.coffee
	mv -f lib/assets/javascripts/password_feedback.js.js lib/assets/javascripts/password_feedback.js
	sass lib/assets/stylesheets/password_feedback.sass lib/assets/stylesheets/password_feedback.css
