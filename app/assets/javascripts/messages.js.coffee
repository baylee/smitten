$ ->
  refresh_messages_container = () ->
    $.ajax
      dataType: 'script'
      url: document.URL

  start_timer = () ->
    clock = setInterval(refresh_messages_container, 10000)

  if $('#messages_container').length != 0
    start_timer()