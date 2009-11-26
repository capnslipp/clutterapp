// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults



jQuery.ajaxSetup({beforeSend: function(xhr) {
	xhr.setRequestHeader("Accept", "text/javascript");
} });

jQuery.fn.walk = function() {
	var firstChild = this.children(':first');
	if (firstChild[0]) {
		return firstChild;
	} else {
		var nextSibling = this.next()
		if (nextSibling[0])
			return nextSibling;
		else
			return this.closest(':not(:last-child)').next();
	}
}



JOIN = '_';
NEW = 'new';

kDefaultTransitionDuration = 125


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
	console.assert(nodeBody[0], 'nodeBody[0]');
	
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
	console.assert(node[0], 'node[0]');
	
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

$(function() {
	$('.action.stub .widget.collapsed a').live('click', function() {
		expandActionBar($(this).closest('.item_for_node')); return false;
	});
	
	$('#action-bar .widget.expanded a')
		.click(function() { collapseActionBar(); return false; });
	
	var actionButtons = $('#action-bar .buttons');
	console.assert(actionButtons[0], 'actionButtons[0]');
	
	actionButtons.find('a.toggle.new-bar')
		.click(function() { toggleItemNewBar($(this).closest('.item_for_node')); return false; });
	
	$('#new-bar .widget.expanded a')
		.click(function() { hideItemNewBar(); return false; });
});



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
		if (modalElement != undefined)
		{
			//alert(modalElement.cssPosition);
			//if (modalElement.cssPosition != 'absolute') {
			//	modalElement.attr('oc\:origPosition', modalElement.css('position'));
			//	modalElement.css('position', 'relative');
			//}
			
			modalElement.css('z-index', 1000);
		}
	
		$('#fill').fadeIn(kDefaultTransitionDuration);
	}
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


function nodeItemNew(parentNode, type) {
	$.ajax({
		type: 'get',
		data: {type: type, parent_id: nodeIDOfItem(parentNode)},
		url: parentNode.closest('.pile').attr('oc\:nodes-url') + '/new',
		dataType: 'html',
		success: function(responseData) { handleSuccess(parentNode, type, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(parentNode, type, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(parentNode, type, responseData) {
		collapseActionBar();
		
		var list = parentNode.children('.list');
		console.assert(list[0], 'list[0]');
		
		if (list.children('#new-bar').length != 0)
			list.children('#new-bar').before(responseData);
		else
			list.append(responseData);
		
		var newBody = list.children('.item_for_node:last').find('.new.body');
		console.assert(newBody[0], 'newBody[0]');
		
		newBody.find('.note.prop').find('textarea').elastic();
		
		showFill(newBody);
		
		var newBodyForm = newBody.find('form');
		console.assert(newBodyForm[0], 'newBodyForm[0]');
		editFormFocus(newBodyForm);
	}
	
	function handleError(parentNode, type, xhrObj, errStr, expObj) {
		parentNode.find('#new-bar:first')
			.effect('highlight', {color: 'rgba(153, 17, 0, 0.9)'}, 2000);
	}
}
	
$(function() {
	var newButtons = $('#new-bar .buttons');
	console.assert(newButtons[0], 'newButtons[0]');
	
	newButtons.find('a.new.text')
		.click(function() { nodeItemNew($(this).closest('.item_for_node'), 'text'); return false; });
	newButtons.find('a.new.check')
		.click(function() { nodeItemNew($(this).closest('.item_for_node'), 'check'); return false; });
	newButtons.find('a.new.note')
		.click(function() { nodeItemNew($(this).closest('.item_for_node'), 'note'); return false; });
	newButtons.find('a.new.priority')
		.click(function() { nodeItemNew($(this).closest('.item_for_node'), 'priority'); return false; });
	newButtons.find('a.new.tag')
		.click(function() { nodeItemNew($(this).closest('.item_for_node'), 'tag'); return false; });
	newButtons.find('a.new.time')
		.click(function() { nodeItemNew($(this).closest('.item_for_node'), 'time'); return false; });
	newButtons.find('a.new.pile-ref')
		.click(function() { nodeItemNew($(this).closest('.item_for_node'), 'pile-ref'); return false; });
});



function nodeItemCreate(form) {
	$.ajax({
		type: form.attr('method'), // 'post'
		url: form.attr('action'),
		data: form.formSerialize(),
		dataType: 'html',
		success: function(responseData) { handleSuccess(form, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(form, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(form, responseData) {
		var newBody = form.closest('.new.body');
		console.assert(newBody[0], 'newBody[0]');
		
		hideFill(newBody);
		
		var newItem = newBody.closest('.item_for_node');
		console.assert(newItem[0], 'newItem[0]');
		
		newItem.replaceWith(responseData);
	}
	
	function handleError(form, xhrObj, errStr, expObj) {
		var newProp = form.closest('.new.prop');
		console.assert(newProp[0], 'newProp[0]');
		newProp.effect('highlight', {color: 'rgba(153, 17, 0, 0.9)'}, 2000);
		
		console.assert(form[0], 'form[0]');
		editFormFocus(form);
	}
}

$(function() {
	$('form.new_node').live('submit', function() {
		nodeItemCreate($(this)); return false;
	});
});


function editFormFocus(form) {
	form.children('.field:first')
		.focus();
}

function nodeItemEdit(showBody) {
	$.ajax({
		type: 'get',
		url: showBody.closest('.node').attr('oc\:url') + '/edit',
		dataType: 'html',
		success: function(responseData) { handleSuccess(showBody, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(showBody, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(showBody, responseData) {
		collapseActionBar();
		
		showBody.before(responseData);
		
		var editBody = showBody.siblings('.edit.body');
		console.assert(editBody[0], 'editBody[0]');
		
		editBody.find('.note.prop').find('textarea').elastic();
		
		showFill(editBody);
		editFormFocus(editBody.find('form'));
	}
	
	function handleError(showBody, xhrObj, errStr, expObj) {
		showBody
			.effect('highlight', {color: 'rgba(153, 17, 0, 0.9)'}, 2000);
	}
}

$(function() {
	$('.item_for_node > .show.body').live('click', function() {
		nodeItemEdit($(this)); return false;
	});
});


function nodeItemUpdate(form) {
	$.ajax({
		type: form.attr('method'), // 'post' (PUT)
		url: form.attr('action'),
		data: form.formSerialize(),
		dataType: 'html',
		success: function(responseData) { handleSuccess(form, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(form, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(form, responseData) {
		var editBody = form.closest('.edit.body');
		console.assert(editBody[0], 'editBody[0]');
		
		hideFill(editBody);
		
		var showBody = editBody.siblings('.show.body');
		console.assert(showBody[0], 'showBody[0]');
		
		editBody.remove();
		
		showBody.replaceWith(responseData);
	}
	
	function handleError(form, xhrObj, errStr, expObj) {
		form.closest('.edit.prop')
			.effect('highlight', {color: 'rgba(153, 17, 0, 0.9)'}, 2000);
		
		editFormFocus(form);
	}
}

$(function() {
	$('form.edit_node').live('submit', function() {
		nodeItemUpdate($(this)); return false;
	});
});



function nodeItemMove(node, dir) {
	$.ajax({
		type: 'post',
		data: {_method: 'put', dir: dir},
		url: node.attr('oc\:url') + '/move',
		dataType: 'script',
		success: function(responseData) { handleSuccess(node, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(node, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(node, responseData) {
		// nothing for now; @todo: do the actual element movement here
	}
	
	function handleError(node, xhrObj, errStr, expObj) {
		node.find('.body:first')
			.effect('highlight', {color: 'rgba(153, 17, 0, 0.9)'}, 2000);
	}
}
	
$(function() {
	var actionButtons = $('#action-bar .buttons');
	console.assert(actionButtons[0], 'actionButtons[0]');
	
	actionButtons.find('a.move.out')
		.click(function() { nodeItemMove($(this).closest('.item_for_node'), 'out'); return false; });
	actionButtons.find('a.move.up')
		.click(function() { nodeItemMove($(this).closest('.item_for_node'), 'up'); return false; });
	actionButtons.find('a.move.down')
		.click(function() { nodeItemMove($(this).closest('.item_for_node'), 'down'); return false; });
	actionButtons.find('a.move.in')
		.click(function() { nodeItemMove($(this).closest('.item_for_node'), 'in'); return false; });
});



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
			.effect('highlight', {color: 'rgba(153, 17, 0, 0.9)'}, 2000);
	}
}
	
$(function() {
	var actionButtons = $('#action-bar .buttons');
	console.assert(actionButtons[0], 'actionButtons[0]');
	
	actionButtons.find('a.delete')
		.click(function() { nodeItemDelete($(this).closest('.item_for_node')); return false; });
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
