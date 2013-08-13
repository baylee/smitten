$flagged_message_div = $('#flagged_message')
$flagged_spark_div = $('#flagged_spark')

if $flagged_message_div.length != 0
  $flagged_message_div.html('You flagged this conversation. You will not see any new messages.')
else if $flagged_spark_div.length != 0
  $flagged_spark_div.html('Flag saved.')