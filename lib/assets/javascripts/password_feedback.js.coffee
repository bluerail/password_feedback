#= require zxcvbn

'use strict'

req = null

show_feedback = (input, email, password, bar) ->
  req.abort() if req?
  if password is ''
    bar.html ''
    return

  show_feedback_client input, email, password, bar


show_feedback_server = ((input, email, password, bar) ->
  req = jQuery.ajax
    url: '/users/password_score'
    type: 'get'
    dataType: 'json'
    data:
      password: password
      email: email
    success: (data) -> set_feedback bar, data.n, data.strength
).debounce 200


show_feedback_client = (input, email, password, bar) ->
  result = zxcvbn password, [email].concat(email.split(/[^\w]/))
  if result.score is 0
    set_feedback bar, 1, 'weak'
  else if result.score is 4
    set_feedback bar, 3, 'strong'
  else
    set_feedback bar, 2, 'ok'


set_feedback = (bar, n, strength) ->
  bar.find("span:lt(#{n})").attr 'class', "password-feedback-indicator password-feedback-#{strength}"
  bar.find("span:gt(#{n})").attr 'class', 'password-feedback-indicator'


compare = (input, other) ->
  if input.val() is other.val()
    input.closest('.form-group').removeClass 'error has-error'
    input.parent().find('.help-block').remove()
    return

  input.closest('.form-group').addClass 'error has-error'
  help = input.parent().find '.help-block'
  if help.length
    help.html _('not the same as password')
  else
    input.after "<span class='help-block'>#{_('not the same as password')}</span>"


$(document).on 'input', '.input.password_strength input', ->
  input = $(this)

  show_feedback(
    input,
    input.closest('form').find('input[type=email]')?.val()?.trim(),
    input.val(),
    input.closest('.password_strength').find('.password-feedback-bar'))

  input.closest('form').find('.input.password_confirmation input').trigger 'input'


$(document).on 'input', '.input.password_confirmation input', ->
  compare $(this), $($(this).closest('form').find('input[type=password]').not(this)
    .toArray().filter((f) -> f.name.indexOf('[password]') >= 0))


$(document).on 'ready page:load', ->
  $('.password-feedback-help').popover
    placement: 'bottom'
    container: 'body'
    html: true
    content: _('password_help_popover')
