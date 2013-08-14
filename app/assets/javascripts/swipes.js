//This is for the swipe events on the home page, dashboard, and new spark page

$( document ).ready(function(event) {
  var mainwrapper = $("#mainwrapper");
  var new_spark = $("#new_spark_div");
  var homepage = $("#homepage");
  var dashboard = $("#dashboard");
  var other_pages = $("#other_pages");

  new_spark.swipe({
    swipeLeft:function(event, direction, distance, duration, fingerCount) {

      homepage.css('position', 'absolute');
      homepage.css('width', '100%');
      $("#homepage").css('left', '100%');
      dashboard.empty().removeAttr("style");
      new_spark.animate({
        right:'100%',
        opacity: 1
      },{ duration: 500, queue: false});
      $('#homepage').css("display", "block");
      $('#homepage').animate({
        left: "0%",
        opacity: 1
      }, { duration: 500, queue: false});
    }
  });
  dashboard.swipe({
    swipeRight:function(event, direction, distance, duration, fingerCount) {
      homepage.css('position', 'absolute');
      homepage.css('width', '100%');
      new_spark.empty().removeAttr("style");

      var backtohome = function(){
        dashboard.animate({
          left:'100%',
          opacity: 1
        },{ duration: 500, queue: false});
        $('#homepage').css("display", "block");
        $('#homepage').animate({
          right: "0%",
          opacity: 1
        }, { duration: 500, queue: false});
      };
      backtohome();
      dashboard.empty().removeAttr("style");
    }
  });
  homepage.swipe({
    swipe:function(event, direction, distance, duration, fingerCount) {
      homepage.empty().removeAttr('style');
      if (direction === "right"){
        $.getScript("swipe_to_spark");

      }
      if(direction === "left"){
        $.getScript("swipe_to_dash");
      }
    },
      allowPageScroll:"auto"
      //here we are on the homepage, we can either go left or right, allow page scroll lets you do the normal stuff with up and down
  });
});
