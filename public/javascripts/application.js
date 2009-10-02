// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults



jQuery.ajaxSetup({beforeSend: function(xhr) {
	xhr.setRequestHeader("Accept", "text/javascript");
} });

jQuery.fn.walk = function() {
	var firstChild = this.children(':first');
	if (firstChild.length > 0) {
		return firstChild;
	} else {
		var nextSibling = this.next()
		if (nextSibling.length > 0)
			return nextSibling;
		else
			return this.closest(':not(:last-child)').next();
	}
}



JOIN = '_';
NEW = 'new';


function classForNodeModels(prefix) {
	if (prefix == undefined)
		return 'node'
	else
		return prefix + JOIN + 'node'
}


function idForNodeModel(recordID, prefix) {
	if (recordID != '')
		return classForNodeModels(prefix) + JOIN + recordID
	else
		return (prefix == undefined) ? classForNodeModels(NEW) : classForNodeModels(prefix)
}



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


function expandActionBar(node) {
	collapseActionBar();
	
	
	node.children('.body').children('.action.stub')
		.hide();
	
	var nodeBody = node.children('.body');
	if (nodeBody.find('#action-bar').length == 0)
		$('#action-bar').prependTo(nodeBody);
	
	// since it may be initially-hidden
	safeShow($('#action-bar'));
}

function collapseActionBar() {
	hideItemNewBar();
	
	$('#action-bar')
		.hide()
	
	var node = $('#action-bar').closest('.item_for_node');
	node.children('.body').children('.action.stub')
		.show();
		
	$('#action-bar')
		.appendTo($('.pile:first')); // in case the parent item gets deleted
}

function toggleItemNewBar(node) {
	if ($('#new-bar').is(':visible'))
		hideItemNewBar(node);
	else
		showItemNewBar(node);
}

function showItemNewBar(node) {
	if (node.find('#new-bar').length == 0)
		$('#new-bar').appendTo(node.children('.list'));
	
	// since it may be initially-hidden
	safeShow($('#new-bar'));
}

function hideItemNewBar() {
	$('#new-bar')
		.hide()
		.appendTo($('.pile:first')); // in case the parent item gets deleted
}



function nodeIDOfContainingItem(elem) {
	return nodeIDOfItem( elem.closest('.item_for_node') );
}

function nodeIDOfItem(itemForNode) {
	return itemForNode.attr('id').substring('item_for_node_'.length);
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
	if (!$('#fill').is(':visible')) {
		if (modalElement != undefined) {
			modalElement.attr('oc\:origPosition', modalElement.css('position'));
			modalElement
				.css('position', 'relative')
				.css('z-index', 1000);
		}
	
		$('#fill').fadeIn(500);
	}
}

function hideFill(modalElement) {
	if ($('#fill').is(':visible')) {
		$('#fill').fadeOut(333);
	
		if (modalElement != undefined) {
			modalElement
				.css({
					position: modalElement.attr('oc\:origPosition'),
					zIndex: 0
				});
		}
	}
}


function editFormFocus(form) {
	form.children('.field:first')
		.focus();
}

function editFormShow(prop) {
	$.ajax({
		type: 'get',
		url: prop.closest('.node').attr('oc\:editUrl'),
		dataType: 'html',
		success: function(responseData) { handleSuccess(prop, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(prop, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(showProp, responseData) {
		var body = showProp.parent('.body');
		
		showProp
			.replaceWith(responseData);
		
		var editProp = body.children('.edit.prop');
		
		editProp.filter('.note.prop').find('textarea').elastic();
		
		showFill(editProp);
		editFormFocus(editProp.children('form'));
	}
	
	function handleError(prop, xhrObj, errStr, expObj) {
		prop
			.effect('highlight', {color: '#910'}, 2000);
	}
}

$(function() {
	$('.item_for_node > .body > .show.prop').live('click', function() {
		editFormShow($(this)); return false;
	});
});



function nodeItemCreate(parentNode, type) {
	$.ajax({
		type: 'post',
		data: {type: type, parent_id: nodeIDOfItem(parentNode)},
		url: parentNode.closest('.pile').attr('oc\:nodesUrl'),
		dataType: 'html',
		success: function(responseData) { handleSuccess(parentNode, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(parentNode, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(parentNode, responseData) {
		var list = parentNode.children('.list');
		
		if (list.children('#new-bar').length != 0)
			list.children('#new-bar').before(responseData);
		else
			list.append(responseData);
		
		var editProp = list.children('.item_for_node:last').children('.body').children('.edit.prop');
		
		editProp.filter('.note.prop').find('textarea').elastic();
		
		showFill(editProp);
		editFormFocus(editProp.children('form'));
	}
	
	function handleError(parentNode, xhrObj, errStr, expObj) {
		parentNode.find('#new-bar:first')
			.effect('highlight', {color: '#910'}, 2000);
	}
}


function editFormSubmit(form) {
	$.ajax({
		type: form.attr('method'),
		url: form.attr('action'),
		data: form.formSerialize(false),
		dataType: 'html',
		success: function(responseData) { handleSuccess(form, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(form, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(form, responseData) {
		var editProp = form.closest('.edit.prop');
		
		hideFill( editProp.parent('.body') );
		
		editProp
			.replaceWith(responseData);
	}
	
	function handleError(form, xhrObj, errStr, expObj) {
		form.closest('.edit.prop')
			.effect('highlight', {color: '#910'}, 2000);
		
		editFormFocus(form);
	}
}

$(function() {
	$('form.edit_node').live('submit', function() {
		editFormSubmit($(this)); return false;
	});
});



function nodeItemMove(node, dir) {
	$.ajax({
		type: 'post',
		data: {_method: 'put', dir: dir},
		url: node.attr('oc\:moveUrl'),
		dataType: 'script',
		success: function(responseData) { handleSuccess(node, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(node, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(node, responseData) {
		// nothing for now; @todo: do the actual element movement here
	}
	
	function handleError(node, xhrObj, errStr, expObj) {
		node.find('.body:first')
			.effect('highlight', {color: '#910'}, 2000);
	}
}



function nodeItemDelete(node) {
	$.ajax({
		type: 'post',
		data: {_method: 'delete'},
		url: node.attr('oc\:url'),
		dataType: 'html',
		success: function(responseData) { handleSuccess(node, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(node, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(node, responseData) {
		collapseActionBar();
		node.remove();
	}
	
	function handleError(node, xhrObj, errStr, expObj) {
		node.find('.body:first')
			.effect('highlight', {color: '#910'}, 2000);
	}
}


$(function() {
	$('.action.stub .widget.collapsed a').live('click', function() {
		expandActionBar($(this).closest('.item_for_node')); return false;
	});
	
	$('#action-bar .widget.expanded a')
		.click(function() { collapseActionBar(); return false; })
	
	var actionButtons = $('#action-bar .buttons');
	actionButtons.find('a.move.out')
		.click(function() { nodeItemMove($(this).closest('.item_for_node'), 'out'); return false; });
	actionButtons.find('a.move.up')
		.click(function() { nodeItemMove($(this).closest('.item_for_node'), 'up'); return false; });
	actionButtons.find('a.move.down')
		.click(function() { nodeItemMove($(this).closest('.item_for_node'), 'down'); return false; });
	actionButtons.find('a.move.in')
		.click(function() { nodeItemMove($(this).closest('.item_for_node'), 'in'); return false; });
	
	actionButtons.find('a.delete')
		.click(function() { nodeItemDelete($(this).closest('.item_for_node')); return false; });
	
	actionButtons.find('a.toggle.new-bar')
		.click(function() { toggleItemNewBar($(this).closest('.item_for_node')); return false; });
	
	
	$('#new-bar .widget.expanded a')
		.click(function() { hideItemNewBar(); return false; })
	
	var newButtons = $('#new-bar .buttons');
	newButtons.find('a.new.text')
		.click(function() { nodeItemCreate($(this).closest('.item_for_node'), 'text'); return false; })
	newButtons.find('a.new.check')
		.click(function() { nodeItemCreate($(this).closest('.item_for_node'), 'check'); return false; })
	newButtons.find('a.new.note')
		.click(function() { nodeItemCreate($(this).closest('.item_for_node'), 'note'); return false; })
	newButtons.find('a.new.priority')
		.click(function() { nodeItemCreate($(this).closest('.item_for_node'), 'priority'); return false; })
	newButtons.find('a.new.tag')
		.click(function() { nodeItemCreate($(this).closest('.item_for_node'), 'tag'); return false; })
	newButtons.find('a.new.time')
		.click(function() { nodeItemCreate($(this).closest('.item_for_node'), 'time'); return false; })
});



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
