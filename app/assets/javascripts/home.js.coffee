$ ->

# --------------- All this is for updating location --------------------
  create_location_only_spark = () ->
    handleNoGeolocation = (errorFlag) ->
      if (errorFlag)
        console.log("Geolocation service failed.")
      else
        console.log("Your browser doesn't support geolocation.")

    # if browser supports geolocation
    if(navigator.geolocation)
      navigator.geolocation.getCurrentPosition((position) ->
        # if success
        window.latitude = position.coords.latitude
        window.longitude = position.coords.longitude
        send_ajax()
      ,
      # if error
      () ->
        handleNoGeolocation(true)
      )
    # If browser doesn't support Geolocation
    else
      handleNoGeolocation(false)

    # once the geolocation succeeds, send the latitude and longitude
    send_ajax = ->
      spark_data =
        latitude: window.latitude
        longitude: window.longitude

      $.ajax
        dataType: "script"
        url: "/update_location"
        method: "POST"
        data: spark_data

  $('body').on("click", "#update_location", create_location_only_spark)

# --------------- End of updating location --------------------

# --------------- This is for endless scroll --------------------
  # While there is still pagination on the page:
  if ($('.pagination').length)

    # Detect the 'scroll' event:
    $(window).scroll ->

      # Get the next URL from pagination.
      url = $('.pagination .next_page').attr('href')

      # $(window).scrollTop() represents where I've scrolled to.
      # $(document).height() represents the height of the document content, which changes.
      # $(window).height() - represents the screen height, which does not change.
      #
      # The final calculation is then whenever I scroll past 50px form the bottom.
      #
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 10)
        $('.pagination').text("Fetching more articles...")

        # http://api.jquery.com/jQuery.getScript/
        # Alias for $.ajax, assumes dataType:"script".
        return $.getScript(url)

    # Trigger a scroll off the bat.
    return $(window).scroll()
# --------------- End of endless scroll --------------------
