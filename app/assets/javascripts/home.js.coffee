# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  create_location_only_spark = () ->
    handleNoGeolocation = (errorFlag) ->
      if (errorFlag)
        console.log("Geolocation service failed.")
      else
        console.log("Your browser doesn't support geolocation.")

    if(navigator.geolocation)
      console.log "made it to geolocation"
      navigator.geolocation.getCurrentPosition((position) ->
        window.latitude = position.coords.latitude
        window.longitude = position.coords.longitude
        send_ajax()

      ,

      () ->
        handleNoGeolocation(true)
      )

    # If browser doesn't support Geolocation
    else
      handleNoGeolocation(false)

    send_ajax = ->
      spark_data =
        latitude: window.latitude
        longitude: window.longitude

      $.ajax
        dataType: "script"
        url: "/update_location"
        method: "POST"
        data: spark_data



  $('#update_location').on("click", create_location_only_spark)