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
		checkbox.checked = (checkbox.getAttr('checked') == 'checked');
	
	checkbox.setAttr('disabled', true);
}


function updateCheckPropField(checkbox, checked) {
	checkbox = $('#' + checkbox);
	
	checkbox.setAttr('checked', checked);
	checkbox.checked = checked;
	checkbox.setAttr('disabled', false);
}


// currently unused
kSlideHideArgs = {width: 'hide'};
kSlideShowArgs = {width: 'show'};
kSlideToggleArgs = {width: 'toggle'};


// for elements that may have been initially-hidden
function safeShow(elem) {
	var display = elem.getAttr('oc\:display');
	if (display != undefined)
		elem.setCSS('display', display);
	else
		elem.show();
}

function showGoogleChromeFrame() {
	$("#top-bar > .corner").fadeOut(1000);
	
	$('#fill')
		.setCSS('z-index', 900)
		.setCSS('opacity', 0)
		.show()
		.animate({opacity: 0.5, easing: 'linear'}, 4000);
}

function showFill(modalElement) {
	if (modalElement != undefined) {
		//alert(modalElement.cssPosition);
		//if (modalElement.cssPosition != 'absolute') {
		//	modalElement.setData('origPosition', modalElement.getCSS('position'));
		//	modalElement.setCSS('position', 'relative');
		//}
		modalElement.setCSS('z-index', 1000);
	}
	
	if (!$('#fill').is(':visible'))
		$('#fill').fadeIn(kDefaultTransitionDuration);
}

function hideFill(modalElement) {
	if ($('#fill').is(':visible'))
		$('#fill').fadeOut(kDefaultTransitionDuration);
	
	if (modalElement != undefined) {
		modalElement.setCSS('z-index', 0);
		
		if (modalElement.getData('origPosition'))
			modalElement.setCSS('position', modalElement.getData('origPosition'));
	}
}


// a zoomable mobile device like the iPhone
if (window.orientation != undefined) {
	kIPhoneScreenHeight = 480;
	kIPhoneStatusBarHeight = 20;
	kIPhoneToolBarHeight = 44;
	
	$(window).load(function() {
		$('body').setCSS('min-height', kIPhoneScreenHeight - kIPhoneStatusBarHeight - kIPhoneToolBarHeight);
		
		setTimeout(function() {
			window.scrollTo(0, 0);
		}, 0);
	});
}

//kOrigViewportWidth = $('meta[name=viewport]').getAttr('content');
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
//			//$('meta[name=viewport]').setAttr(
//			//	'content',
//			//	'user-scalable=' + (kUserScalable ? 'yes' : 'no') + ';'
//			//		+ ' width=' + newWidth
//			//);
//			//$('body').setCSS('width', newWidth);
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
