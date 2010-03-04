// ClutterApp touch compatibilty JS

$(function() {
	$.support.touch = (typeof Touch == "object");
	
	if ($.support.touch) {
		$('#main-area').css({position: 'static'});
		$('#page').css({position: 'relative', top: 'auto', bottom: 'auto'});
	}
});
