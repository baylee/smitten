$( document ).ready(function(event) {
  $("#new_spark_div").swipe({
    swipeLeft:function(event, direction, distance, duration, fingerCount) {
      $("#homebutton").click();
    }
  });
  $("#dashboard").swipe({
    swipeRight:function(event, direction, distance, duration, fingerCount) {
      $("#homebutton").click();
    }
  });
  $("#homepage").swipe({
    swipe:function(event, direction, distance, duration, fingerCount) {
      if (direction === "right"){
        $("#sparkbutton").click();
      }
      if(direction === "left"){
        $("#dashbutton").click();
      }
    }
  });
});
// $("div:jqmData(role='page')")