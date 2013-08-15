$('#spark_feed').empty().append("<%= j render 'home/spark_feed' %>")
$('#update_location').css('display', 'block')
$('#location_alert').html("Location Updated!")
setTimeout -> $('#location_alert').empty()
  ,
  5000