// ClutterApp main application JS


var ClutterApp = {};


jQuery.ajaxSetup({beforeSend: function(xhr) {
	xhr.setRequestHeader("Accept", "text/javascript");
} });


ClutterApp.fsm = {
	// "action" is a string corresponding to the current Rails action or null if not currently in an action.
	_action: null,
	action: function() { return this._action; },
	
	// "state" is a string corresponding to the state of the action (entering, exiting, waiting, etc.), or null if waiting on the user's next move.
	_state: 'loading',
	state: function() { return this._state; },
	
	// "context" is an optional jQuery object pointing to the element(s) currently being manipulated.
	// Possible future use: allowing multiple calls to the server at a time, as long as they don't overlap.
	_context: null,
	context: function() { return this._content; },
	
	
	// checks to see if a state is active
	isStateBusy: function() {
		return this.state() != null;
	},
	
	// checks to see if a action is active
	isActionBusy: function() {
		return this.action() != null;
	},
	
	// checks to see if a state or action is active
	isBusy: function() {
		return this.isStateBusy() || this.isActionBusy();
	},
	
	
	// changes the action, state, and context, given not being busy with something else already
	changeAction: function(newAction, newState, newContext) {
		if (this._action != null) // check that there is no current action
			return false; // busy with an action already
		
		if (this._state != null) // check that there is no current state 
			return false; // busy with a state already
		
		
		if (!(newAction.constructor == String))
			return null;
		
		if (!(newState.constructor == String))
			return null;
		
		if (newContext == undefined)
			newContext = null;
		if (!(newContext == null || newContext instanceof jQuery))
			return null;
		
		
		this._action = newAction;
		this._state = newState;
		this._context = newContext;
		
		return true;
	},
	
	// clears out both the action and the state, leaving it back in the complete idle state (thus, any action allowed)
	finishAction: function(checkAction, checkState) {
		if (this._action != checkAction)
			return false; // a different action than expected is active; sorry, no change
		if (this._state != checkState)
			return false; // a different state than expected is active; sorry, no change
		
		
		this._action = null; // action is back to none
		this._state = null; // state is back to idling
		
		return true;
	},
	
	// changes the state and context, given already being in the given action and not being busy with something else already
	changeState: function(checkAction, newState, newContext) {
		if (this._action != checkAction) // check that the action matches (finishAction to clear out the action)
			return false; // busy with a different action already
		
		if (this._state != null) // check that there is no current state 
			return false; // busy with a state already
		
		
		if (!(newState.constructor == String))
			return null;
		
		if (newContext == undefined)
			newContext = null;
		if (!(newContext == null || newContext instanceof jQuery))
			return null;
		
		
		this._state = newState;
		this._context = newContext;
		
		return true;
	},
	
	// clears out the state, leaving it in an idle state for the current action (thus, new state for this action allowed)
	finishState: function(checkAction, checkState) {
		if (this._action != checkAction)
			return false; // a different action than expected is active; sorry, no change
		if (this._state != checkState)
			return false; // a different state than expected is active; sorry, no change
		
		
		this._state = null; // state is back to idling (in this action)
		
		return true;
	},
};

$(function() {
	ClutterApp.fsm.finishState(null, 'loading');
});



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
var kSlideHideArgs = {width: 'hide'};
var kSlideShowArgs = {width: 'show'};
var kSlideToggleArgs = {width: 'toggle'};


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
		modalElement.addClass('over-fill');
	}
	
	if (!$('#fill').is(':visible'))
		$('#fill').fadeIn(kDefaultTransitionDuration);
}

function hideFill(modalElement) {
	if ($('#fill').is(':visible')) {
		$('#fill').fadeOut(
			kDefaultTransitionDuration,
			showModalElement
		);
	} else {
		showModalElement();
	}
	
	function showModalElement() {
		if (modalElement != undefined) {
			modalElement.removeClass('over-fill');
			
			if (modalElement.getData('origPosition'))
				modalElement.setCSS('position', modalElement.getData('origPosition'));
		}
	}
}



var kPreShowProgressDelay = 500;

// first creates a "#progress-overlay" element as a child of the element called on, then fades and animates it in
jQuery.fn.showProgressOverlay = function(options) {
	if (options == undefined) options = {};
	var targetOpacity = options.opacity || 0.75;
	
	if ($('#progress-overlay')[0]) {
		var oldOverlay = hideProgressOverlay();
		oldOverlay.setAttr('id', '');
	}
	
	// only act on one element
	var parent = $(this[0]).required();
	parent.prepend('<div id="progress-overlay" class="overlay"></div>');
	
	var overlay = $('#progress-overlay').required();
	
	overlay.setCSS(
		{opacity: 0.0}
	).animate(
		{opacity: 0.0}, kPreShowProgressDelay, 'linear', // delay for a bit before starting
		function() {
			overlay.setCSS(
				{opacity: 0.1, backgroundPosition: '0px 0px', backgroundImage: 'url("/images/anim.progress.in.bk-tr-aliased-white.16x32.gif")'}
			).animate(
				{opacity: targetOpacity, backgroundPosition: '16px 0px'}, 500, 'easeInQuad',
				function() {
					setTimeout('animateProgressOverlay()', 0);
				}
			);
		}
	);
	
	return overlay;
}

// animates out the "#progress-overlay" element for a while, then loops by calling itself
function animateProgressOverlay() {
	var overlay = $("#progress-overlay");
	
	// early out if the overlay is already gone
	if (!overlay[0])
		return null;
	
	overlay.setCSS({
		backgroundPosition: '0px 0px',
		/*backgroundImage: 'url("/images/anim.progress.full.bk-tr.16x32.png")'*/ // setting the backgroundImage to the last frame may cause a jump in animation
	}).animate(
		{backgroundPosition: '1600px 0px'}, 50000, 'linear',
		function() {
			setTimeout('animateProgressOverlay()', 0);
		}
	);
	
	return overlay;
}

// fades and animates out the "#progress-overlay" element
function hideProgressOverlay() {
	var overlay = $('#progress-overlay').required();
	
	overlay.stop(true, false);
	
	var overlayOpacity = overlay.getCSS('opacity');
	if (overlayOpacity < 0.1) {
		// if barely visible, just hide it
		overlay.remove();
	} else {
		// if already visible, fade out
		var overlayBGPosX = overlay.getCSS('backgroundPosition').asBGPosToArray()[0];
		
		overlay.setCSS(
			{backgroundImage: 'url("/images/anim.progress.out.bk-tr-aliased-white.16x32.gif")'}
		).animate(
			{opacity: 0.1, backgroundPosition: (overlayBGPosX + 16) + 'px 0px'},
			500,
			'easeOutQuad',
			function() {
				overlay.remove(); // remove this specific instance, in case it has lost the "progress-overlay" id
			}
		);
	}
	
	return overlay;
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
