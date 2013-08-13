//This is for the swipe events on the home page, dashboard, and new spark page

$( document ).ready(function(event) {
  var homebutton =  $("#homebutton");
  var sparkbutton = $("#sparkbutton");
  var dashbutton =  $("#dashbutton");

  $("#new_spark_div").swipe({
    swipeLeft:function(event, direction, distance, duration, fingerCount) {
      var new_spark = $("#new_spark_div");
      var homepage = $("#homepage");
      var dashboard = $("#dashboard");
      homepage.css('left', '100%');
      homepage.css('display', 'block');
      new_spark.removeAttr("style");
      dashboard.removeAttr("style");
      homepage.css('zindex', '1000');
      homepage.animate({
      left: "0%",
      opacity: 1
      }, 500 );

      //when you swipe on the container div new_spark, click on the homebutton link
    }
  });
  $("#dashboard").swipe({
    swipeRight:function(event, direction, distance, duration, fingerCount) {
      homebutton.click();
      //same when you are on the dashboard page
    }
  });
  $("#homepage").swipe({
    swipe:function(event, direction, distance, duration, fingerCount) {
      if (direction === "right"){
        sparkbutton.click();

      }
      if(direction === "left"){
        dashbutton.click();
      }
    },
      allowPageScroll:"auto"
      //here we are on the homepage, we can either go left or right, allow page scroll lets you do the normal stuff with up and down
  });
});
