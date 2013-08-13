$ ->
  reveal_form = ->
    $('#new_flag').css('display', 'block')

  $('#flag_link').on('click', reveal_form)