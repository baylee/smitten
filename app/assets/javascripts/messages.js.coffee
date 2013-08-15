$ ->
  refresh_messages_container = () ->
    if $('#flag_sender_id') != undefined
      console.log 'anything'
      $.ajax
        dataType: 'script'
        url: "messages/#{$('#flag_sender_id').val()}"

  # the timer refreshes the messages on the page every 10 seconds
  start_timer = () ->
    clock = setInterval(refresh_messages_container, 10000)

  # if on messages page (which is the only page with a #messages_container),
  # then start the timer
  if $('#messages_container').length != 0
    start_timer()