$('#spark_feed').append('<%= j render :partial => "spark_feed" %>')
<% if @nearby_sparks.next_page %>
$('.pagination').replaceWith('<%= j will_paginate(@nearby_sparks) %>')
<% else %>
$('.pagination').remove();
<% end %>