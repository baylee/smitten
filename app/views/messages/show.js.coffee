new_spark = $("#new_spark_div")
homepage = $("#homepage")
dashboard = $("#dashboard")
other_pages = $("#other_pages")
mainwrapper = $("#mainwrapper")

new_spark.empty().removeAttr("style");
dashboard.empty().removeAttr("style");
homepage.empty().removeAttr("style");
other_pages.empty().removeAttr("style").html("<%= j render '/messages/show_partial' %>");

$ ->
  window.clock
  refresh_messages_container = () ->
    if $('#flag_sender_id').length != 0
      $.ajax
        dataType: 'script'
        url: "messages/refresh/#{$('#flag_sender_id').val()}"
    else
      clearInterval(window.clock)

  # the timer refreshes the messages on the page every 10 seconds
  start_timer = () ->
    window.clock = setInterval(refresh_messages_container, 10000)

  # if on messages page (which is the only page with a #messages_container),
  # then start the timer
  if $('#messages_container').length != 0
    start_timer()
