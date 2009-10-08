function flashFlash() {
	$('.flash')
	    .animate({backgroundColor: '#c30'}, 500)
	    .animate({backgroundColor: '#333'}, 1000)
		.fadeOut(5000);
}


$(function() {
    setTimeout('flashFlash()', 500);
});