$(document).ready(function() {

  var ask_for_geolocation = function() {

    function handleNoGeolocation(errorFlag) {
      if (errorFlag) {
        console.log("Geolocation service failed.");
      } else {
        console.log("Your browser doesn't support geolocation.");
      }
    }

    if(navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        latitude = position.coords.latitude;
        longitude = position.coords.longitude;
        send_data();
      },

      function() {
        handleNoGeolocation(true);
      });
    }
    // If browser doesn't support Geolocation
    else {
      handleNoGeolocation(false);
    }

    // Add geolocated lat and long to the hidden form fields for new spark
    var send_data = function() {
      $("#lat").val(latitude);
      $("#lon").val(longitude);
      // the following are for the "drop a pin" button
      $("#lat2").val(latitude);
      $("#lon2").val(longitude);

      $("#geolocation_status").empty().append("<p>This spark will be associated with your current location - lat: " + latitude + ", long: " + longitude + "<p>");
    };
  };

  if ($('#geolocation_status').length !== 0){
    ask_for_geolocation();
  }

});






