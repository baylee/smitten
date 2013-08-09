$('#message_content').val("")

$('#messages_container').empty().append("<%= j render 'messages' %>")