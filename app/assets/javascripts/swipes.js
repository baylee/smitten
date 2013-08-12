$( document ).ready(function(event) {
  var homelink1 = $("swipeleft");
  var homelink2 = $("swiperight");

  $( document ).on('swipe', function(event){
    // because the document is only ready once, I want the function to be called after each new swipe
    event.stopImmediatePropagation();
    // The function above stops events from bubbling up
    function homeswipeoptions(){
      // The function above will only be called when on the rootpage
      $("div").on( "swipeleft", function(event) {
        event.stopImmediatePropagation();
        // alert("swipe left happened");
        _.once($("#swipeleft").click());
        // alert("clicked on swipe left");
        });
      $("div").on( "swiperight", function(event) {
        event.stopImmediatePropagation();
        // alert("swipe right happened");
        _.once($("#swiperight").click());
        // alert("clicked on swipe right");
        });
    }//end of homeswipe function

    function swipetohome(){
      // The function above will only be called when not on the home page
      $(document).on("swipeleft", function(event){
        event.stopImmediatePropagation();
        // alert("swipe left happened");
        _.once($("#sparkhome").click());
        // alert("clicked sparkhome");
      });
      $(document).on("swiperight", function(event){
        event.stopImmediatePropagation();
        // alert("swipe right happened");
        _.once($("#dashhome").click());
        // alert("clicked on dashhome");
      });
    }

  if (window.location.pathname === '/') {
    //if the url is for the root, then do this function
    homeswipeoptions();
    // alert("leaving home");
  }

  else{
    //else run this function
    // alert("new divs");
    swipetohome();
  }

  });

});
// $("div:jqmData(role='page')")