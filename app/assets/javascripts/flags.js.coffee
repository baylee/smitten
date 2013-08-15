$ ->
  $new_flag_form = $('#new_flag')

  reveal_form = ->
    $('#new_flag').css('display', 'block')

  $('body').on('click', '#flag_link', reveal_form)

  hide_form = ->
    $('#new_flag').css('display', 'none')

  $('#new_flag').on('submit', hide_form)