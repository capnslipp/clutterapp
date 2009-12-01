// ClutterApp main application JS


jQuery.ajaxSetup({beforeSend: function(xhr) {
	xhr.setRequestHeader("Accept", "text/javascript");
} });



function elementsForNodeModels(prefix) {
	return $('.' + classForNodeModels(prefix))
}


function elementForNodeModel(recordID, prefix) {
	return $('#' + idForNodeModel(recordID, prefix))
}


function preUpdateCheckPropField(checkbox, setToOrigState) {
	checkbox = $('#' + checkbox);
	
	if (setToOrigState == undefined || setToOrigState)
		checkbox.checked = (checkbox.attr('checked') == 'checked');
	
	checkbox.attr('disabled', true);
}


function updateCheckPropField(checkbox, checked) {
	checkbox = $('#' + checkbox);
	
	checkbox.attr('checked', checked);
	checkbox.checked = checked;
	checkbox.attr('disabled', false);
}


// currently unused
kSlideHideArgs = {width: 'hide'};
kSlideShowArgs = {width: 'show'};
kSlideToggleArgs = {width: 'toggle'};


// for elements that may have been initially-hidden
function safeShow(elem) {
	var display = elem.attr('oc\:display');
	if (display != undefined)
		elem.css('display', display);
	else
		elem.show();
}

function showGoogleChromeFrame() {
	$("#top-bar > .corner").fadeOut(1000);
	
	$('#fill')
		.css('z-index', 900)
		.css('opacity', 0)
		.show()
		.animate({opacity: 0.5, easing: 'linear'}, 4000);
}

function showFill(modalElement) {
	if (modalElement != undefined) {
		//alert(modalElement.cssPosition);
		//if (modalElement.cssPosition != 'absolute') {
		//	modalElement.attr('oc\:origPosition', modalElement.css('position'));
		//	modalElement.css('position', 'relative');
		//}
		modalElement.css('z-index', 1000);
	}
	
	if (!$('#fill').is(':visible'))
		$('#fill').fadeIn(kDefaultTransitionDuration);
}

function hideFill(modalElement) {
	if ($('#fill').is(':visible')) {
		$('#fill').fadeOut(kDefaultTransitionDuration);
	
		if (modalElement != undefined)
		{
			modalElement.css('z-index', 0);
			
			if (modalElement.attr('oc\:origPosition'))
				modalElement.css('position', modalElement.attr('oc\:origPosition'));
		}
	}
}


// a zoomable mobile device like the iPhone
if (window.orientation != undefined) {
	kIPhoneScreenHeight = 480;
	kIPhoneStatusBarHeight = 20;
	kIPhoneToolBarHeight = 44;
	
	$(window).load(function() {
		$('body').css('min-height', kIPhoneScreenHeight - kIPhoneStatusBarHeight - kIPhoneToolBarHeight);
		
		setTimeout(function() {
			window.scrollTo(0, 0);
		}, 0);
	});
}

//kOrigViewportWidth = $('meta[name=viewport]').attr('content');
//kOrigOrientation = window.orientation;
//lastOrientation = undefined;
//kPortraitWidth = 320;
//kLandscapeWidth = 480;
////kUserScalable = false;
//
//$(function() {
//	function updateOrientation() {
//		if (lastOrientation != window.orientation) { // just to make sure, since we're basing the new width off the old
//			//alert('changing…');
//			var newWidth = (window.orientation == 0) ? kPortraitWidth : kLandscapeWidth;
//			
//			//$('meta[name=viewport]').attr(
//			//	'content',
//			//	'user-scalable=' + (kUserScalable ? 'yes' : 'no') + ';'
//			//		+ ' width=' + newWidth
//			//);
//			//$('body').css('width', newWidth);
//			
//			lastOrientation = window.orientation;
//		}
//	}
//	
//	window.onorientationchange = updateOrientation;
//	//updateOrientation();
//});


//function writePageMinWidthAdjustment() {
//	// if the screen's width is smaller than the page's width (i.e. a zoomable mobile device like the iPhone)
//	if (window.screen.width < window.innerWidth) {
//		// set the meta-data to the larger of the device's width or the minimum the site needs!
//		
//		newWidth = window.screen.width;
//		if (newWidth < kPageMinWidth)
//			newWidth = kPageMinWidth;
//		
//		// will write the meta tag right into the <head/>
//		document.write('');
//	}
//}
//writePageMinWidthAdjustment();
