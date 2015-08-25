#= require zxcvbn

'use strict'

_ = (s) -> s

window.password_feedback =
  # Which methods to use, can be 'client', 'server', or both
  # The 'client' is instantaneous, but *may* be different from what your
  # server checks. So to be sure it's accurate a server-side check if also
  # recommended.
  # The server-side check is slower, so it will only run when the user stopped
  # typing for a while.
  #methods: ['client', 'server'],
  methods: ['client'],

  # Keep track of the current ajax request (and only allow *one* request)
  _req: null

  # Show feedback
  show_feedback: (input, email, password, bar) ->
    @_req.abort() if @_req?
    return bar.html '' if password is ''
    if 'client' in @methods
      @_get_feedback_client input, email, password, bar

    if 'server' in @methods
      @_get_feedback_server input, email, password, bar


  # Set the feedback indicator
  set_feedback: (bar, n, strength) ->
    bar.find("span:lt(#{n})").attr 'class', "password-feedback-indicator password-feedback-#{strength}"
    bar.find("span:gt(#{n})").attr 'class', 'password-feedback-indicator'


  # Compare if +input+ and +other+ have the same value, and add an error to
  # +input+ if they don't
  compare: (input, other) ->
    if input.val() is other.val()
      @_remove_errors input
      return

    @_add_error input, _('not the same as password')


  # Show some help
  show_help: ->
    return unless jQuery.popover

    $('.password-feedback-help').popover
      placement: 'bottom'
      container: 'body'
      html: true
      content: _('password_help_popover')


  # Get feedback from the server
  #
  # We expect the server to return JSON with the following keys:
  # - n: 
  # - strength: 
  _get_feedback_server: ((input, email, password, bar) ->
    @_req = jQuery.ajax
      url: '/password_feedback/password_score'
      type: 'get'
      dataType: 'json'
      data:
        password: password
        email: email
      success: (data) -> window.password_feedback.set_feedback bar, data.n, data.strength
  ).debounce 200


  # Get feedback from the client (ie. the JS library)
  _get_feedback_client: (input, email, password, bar) ->
    result = zxcvbn password, [email].concat(email.split(/[^\w]/))
    if result.score is 0
      @set_feedback bar, 1, 'weak'
    else if result.score is 4
      @set_feedback bar, 3, 'strong'
    else
      @set_feedback bar, 2, 'ok'



  # Add a text error to +input+
  _add_error: (input, text) ->
    input.closest('.form-group').addClass 'error has-error'
    help = input.parent().find '.help-block'

    if help.length
      help.html text
    else
      input.after "<span class='help-block'>#{text}</span>"


  # Remove all errors from +input+
  _remove_errors: (input) ->
    input.closest('.form-group').removeClass 'error has-error'
    input.parent().find('.help-block').remove()


  _find_or_add_html: (input) ->
    # We need a relative
    if input.parent().css('position') is 'static'
      wrap = $('<span></span>').css 'position', 'relative'
      input.wrap wrap

      input.parent().append '''
        <div class="password-feedback-x">
          <div class="password-feedback-bar">
            <span class="password-feedback-indicator"></span>
            <span class="password-feedback-indicator"></span>
            <span class="password-feedback-indicator"></span>
          </div>
        </div>
      '''

  _bind_feedback_input: (input) ->
    @_find_or_add_html input

    @show_feedback(
      input,
      input.closest('form').find('input[type=email]')?.val()?.trim(),
      input.val(),
      input.parent().find('.password-feedback-bar'))
      #input.closest('.password-feedback').find('.password-feedback-bar'))

    input.closest('form').find('.password-confirmation').trigger 'input'

  _bind_compare_input: (input) ->
    @compare input, $(input.closest('form').find('input[type=password]').not(input)
      .toArray().filter((f) -> f.name.indexOf('[password]') >= 0))


## Events

$(document).on 'input', '.password-feedback', ->
  window.password_feedback._bind_feedback_input $(this)

$(document).on 'input', '.password-confirmation', ->
  window.password_feedback._bind_compare_input $(this)

#$(document).on 'ready page:load', ->
#  window.password_feedback.show_help()
