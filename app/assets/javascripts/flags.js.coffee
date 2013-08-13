$ ->
  $new_flag_form = $('#new_flag')

  reveal_form = ->
    $new_flag_form.css('display', 'block')

  $('#flag_link').on('click', reveal_form)

  hide_form = ->
    $new_flag_form.css('display', 'none')

  $('#new_flag').on('submit', hide_form)