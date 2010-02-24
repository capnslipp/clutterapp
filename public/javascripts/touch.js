// ClutterApp touch compatibilty JS


$(function() {
	ClutterApp.touchInfo = {
		kMinMoveToScroll: 5,
		kDecelFrictionFactor: 0.95,
		first: null,
		prev: null,
		isScrolling: false,
		origTarget: null,
		momentumY: 0,
		momentumFPS: 1000 / 60,
		momentumIntervalID: null,
	};
	
	var center = $('#main-area').required();
	center[0].ontouchstart = function(e) { touchStarted(e, center); };
	center[0].ontouchmove = function(e) { touchMoved(e, center); };
	center[0].ontouchend = function(e) { touchEnded(e, center); };
	
	var panel = $('#scope-panel');
	if (panel.exists()) {
		panel[0].ontouchstart = function(e) { touchStarted(e, panel); };
		panel[0].ontouchmove = function(e) { touchMoved(e, panel); };
		panel[0].ontouchend = function(e) { touchEnded(e, panel); };
	}
	
	function touchStarted(e, areaElement) {
		var touch = e.changedTouches[0];
		ClutterApp.touchInfo.first = {
			y: touch.screenY,
			id: touch.identifier,
		};
		ClutterApp.touchInfo.prev = ClutterApp.touchInfo.first;
		
		ClutterApp.touchInfo.origTarget = touch.target;
		
		if (ClutterApp.touchInfo.momentumIntervalID)
			clearInterval(ClutterApp.touchInfo.momentumIntervalID);
		ClutterApp.touchInfo.momentumY = 0;
		
		e.preventDefault();
		e.stopPropagation();
	}
	
	function touchMoved(e, areaElement) {
		var touch = e.changedTouches[0];
		var currTouchInfo = {
			y: touch.screenY,
			id: touch.identifier,
		}
		
		// early exit if this is a different finger than the one that started the drag
		if (currTouchInfo.id != ClutterApp.touchInfo.prev.id)
			return;
		
		if (!ClutterApp.touchInfo.isScrolling && Math.abs(ClutterApp.touchInfo.first.y - currTouchInfo.y) >= ClutterApp.touchInfo.kMinMoveToScroll)
			ClutterApp.touchInfo.isScrolling = true;
		
		// early exit if we're not scrolling (yet)
		if (!ClutterApp.touchInfo.isScrolling)
			return;
		
		ClutterApp.touchInfo.momentumY = ClutterApp.touchInfo.prev.y - currTouchInfo.y;
		
		var currScrollY = areaElement.scrollTop();
		areaElement.scrollTop(currScrollY + ClutterApp.touchInfo.momentumY);
		
		ClutterApp.touchInfo.prev = currTouchInfo;
		
		e.stopPropagation();
		
		//for (var property in e)
		//	window.console.log(touch.identifier + ": " + property);
	};
	
	function touchEnded(e, areaElement) {
		var touch = e.changedTouches[0];
		var lastTouchInfo = {
			y: touch.screenY,
			id: touch.identifier,
		}
		
		if (!ClutterApp.touchInfo.isScrolling) {
			var clickEvent = document.createEvent("MouseEvent");
			clickEvent.initMouseEvent("click", true, true, document.defaultView, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, null);
			
			var ot = ClutterApp.touchInfo.origTarget;
			ot.dispatchEvent(clickEvent);
			ClutterApp.touchInfo.origTarget = null;
		} else {
			if (ClutterApp.touchInfo.momentumIntervalID)
				clearInterval(ClutterApp.touchInfo.momentumIntervalID);
			
			ClutterApp.touchInfo.momentumIntervalID = setInterval(function() {
				animateMomentum(areaElement)
			}, ClutterApp.touchInfo.momentumFPS);
			
			ClutterApp.touchInfo.isScrolling = false;
		}
		
		ClutterApp.touchInfo.first = null;
		ClutterApp.touchInfo.prev = null;
		
		e.stopPropagation();
	}
	
	function animateMomentum(areaElement) {
		ClutterApp.touchInfo.momentumY *= ClutterApp.touchInfo.kDecelFrictionFactor;
		
		if (Math.abs(ClutterApp.touchInfo.momentumY) >= 0.25) {
			var currScrollY = areaElement.scrollTop();
			areaElement.scrollTop(currScrollY + ClutterApp.touchInfo.momentumY);
		} else {
			ClutterApp.touchInfo.momentumY = 0;
			clearInterval(ClutterApp.touchInfo.momentumIntervalID);
			ClutterApp.touchInfo.momentumIntervalID = null;
		}
	}
});
