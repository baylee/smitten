$('#spark_feed').empty().append("<%= j render 'home/spark_feed' %>")
$('#location_alert').prepend("Location Updated!")
setTimeout -> $('#location_alert').empty()
  ,
  5000