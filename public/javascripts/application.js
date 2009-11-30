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

jQuery.fn.required = function() {
	if (typeof(console) != 'undefined' && typeof(console.assert) != 'undefined')
		console.assert(this[0]);
	
	return this;
}



JOIN = '_';
NEW = 'new';

kDefaultTransitionDuration = 250;


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
	nodeBody.required();
	
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
	node.required();
	
	node.children('.body').children('.action.stub')
		.show();
		
	$('#action-bar')
		.appendTo($('.pile:first')); // in case the parent item gets deleted
}

$(function() {
	$('.item_for_node > .show.body > .cont').live('click', function() {
		expandActionBar($(this).closest('.item_for_node')); return false;
	});
	$('.pile.item_for_node > .name').live('click', function() {
		expandActionBar($(this).closest('.item_for_node')); return false;
	});
});


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
	
	var actionButtons = $('#action-bar .buttons').required();
	
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


function itemNew(parentNode, type) {
	$.ajax({
		type: 'get',
		url: parentNode.closest('.pile').attr('oc\:nodes-url') + '/new',
		data: {'node[prop_type]': type, 'node[parent_id]': nodeIDOfItem(parentNode)},
		dataType: 'html',
		success: function(responseData) { handleSuccess(parentNode, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(parentNode, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(parentNode, responseData) {
		collapseActionBar();
		
		var list = parentNode.children('.list').required();
		
		if (list.children('#new-bar').length != 0)
			list.children('#new-bar').before(responseData);
		else
			list.append(responseData);
		
		var newBody = list.children('.item_for_node:last').find('.new.body').required();
		newBody.hide().fadeIn(kDefaultTransitionDuration);
		
		newBody.find('.note.prop').find('textarea').elastic();
		
		showFill(newBody);
		
		var newBodyForm = newBody.find('form').required();
		formFocus(newBodyForm.required());
	}
	
	function handleError(parentNode, xhrObj, errStr, expObj) {
		parentNode.find('#new-bar:first')
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}
	
$(function() {
	var newButtons = $('#new-bar .buttons').required();
	
	newButtons.find('a.new.text')
		.click(function() { itemNew($(this).closest('.item_for_node'), 'text'); return false; });
	newButtons.find('a.new.check')
		.click(function() { itemNew($(this).closest('.item_for_node'), 'check'); return false; });
	newButtons.find('a.new.note')
		.click(function() { itemNew($(this).closest('.item_for_node'), 'note'); return false; });
	newButtons.find('a.new.priority')
		.click(function() { itemNew($(this).closest('.item_for_node'), 'priority'); return false; });
	newButtons.find('a.new.tag')
		.click(function() { itemNew($(this).closest('.item_for_node'), 'tag'); return false; });
	newButtons.find('a.new.time')
		.click(function() { itemNew($(this).closest('.item_for_node'), 'time'); return false; });
	newButtons.find('a.new.pile-ref')
		.click(function() { itemNew($(this).closest('.item_for_node'), 'pile-ref'); return false; });
});



function itemCreate(form) {
	form.required();
	
	$.ajax({
		type: form.attr('method'), // 'post'
		url: form.attr('action'),
		data: form.serialize(),
		dataType: 'html',
		success: function(responseData) { handleSuccess(form, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(form, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(form, responseData) {
		var newBody = form.closest('.new.body').required();
		var newItem = newBody.closest('.item_for_node').required();
		
		newItem.after(responseData);
		
		hideFill();
		
		newBody.fadeOut(kDefaultTransitionDuration, function() { $(this).closest('.item_for_node').required().remove(); });
	}
	
	function handleError(form, xhrObj, errStr, expObj) {
		form.required();
		
		form.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		formFocus(form);
	}
}

$(function() {
	$('form.new_node').live('submit', function() {
		itemCreate($(this)); return false;
	});
});


function formFocus(form) {
	form.find('.field:first').required()
		.focus();
}

function itemEdit(link) {
	var showBody = $(link).closest('.show.body').required();
	
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
		
		var editBody = showBody.siblings('.edit.body').required();
		editBody.hide().fadeIn(kDefaultTransitionDuration);
		
		editBody.find('.note.prop').find('textarea').elastic();
		
		showFill(editBody);
		formFocus(editBody.find('form').required());
	}
	
	function handleError(showBody, xhrObj, errStr, expObj) {
		showBody
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}

$(function() {
	$('.item_for_node > .show.body > .cont').live('dblclick', function() {
		itemEdit(this); return false;
	});
	$('#action-bar > .buttons > a.edit').click(function() {
		itemEdit(this); return false;
	});
});


function itemUpdate(form) {
	$.ajax({
		type: form.attr('method'), // 'post' (PUT)
		url: form.attr('action'),
		data: form.serialize(),
		dataType: 'html',
		success: function(responseData) { handleSuccess(form, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(form, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(form, responseData) {
		var editBody = form.closest('.edit.body').required();
		var showBody = editBody.siblings('.show.body').required();
		
		hideFill();
		
		editBody.fadeOut(kDefaultTransitionDuration, function() { $(this).remove(); });
		
		showBody.replaceWith(responseData);
	}
	
	function handleError(form, xhrObj, errStr, expObj) {
		form.required();
		
		form.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		formFocus(form);
	}
}

$(function() {
	$('form.edit_node').live('submit', function() {
		itemUpdate($(this)); return false;
	});
});



function itemMove(node, dir) {
	$.ajax({
		type: 'post',
		url: node.attr('oc\:url') + '/move',
		data: {_method: 'put', dir: dir},
		dataType: 'script',
		success: function(responseData) { handleSuccess(node, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(node, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(node, responseData) {
		// nothing for now; @todo: do the actual element movement here
	}
	
	function handleError(node, xhrObj, errStr, expObj) {
		node.find('.body:first').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}
	
$(function() {
	var actionButtons = $('#action-bar .buttons').required();
	
	actionButtons.find('a.move.out')
		.click(function() { itemMove($(this).closest('.item_for_node'), 'out'); return false; });
	actionButtons.find('a.move.up')
		.click(function() { itemMove($(this).closest('.item_for_node'), 'up'); return false; });
	actionButtons.find('a.move.down')
		.click(function() { itemMove($(this).closest('.item_for_node'), 'down'); return false; });
	actionButtons.find('a.move.in')
		.click(function() { itemMove($(this).closest('.item_for_node'), 'in'); return false; });
});



function itemDelete(node) {
	$.ajax({
		type: 'post',
		url: node.attr('oc\:url'),
		data: {_method: 'delete'},
		dataType: 'html',
		success: function(responseData) { handleSuccess(node, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(node, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(node, responseData) {
		collapseActionBar();
		node.remove();
	}
	
	function handleError(node, xhrObj, errStr, expObj) {
		node.find('.body:first').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}
	
$(function() {
	var actionButtons = $('#action-bar .buttons').required();
	
	actionButtons.find('a.delete')
		.click(function() { itemDelete($(this).closest('.item_for_node')); return false; });
});


function badgeAdd(link, addType) {
	var node = $(link).closest('.item_for_node').required();
	
	var state;
	if (node.children('.new')[0])
		state = 'new';
	else if (node.children('.edit')[0])
		state = 'edit';
	else if (typeof(console) != 'undefined' && typeof(console.assert) != 'undefined')
		console.assert('invalid state');
	
	var form = node.find('form').required();
	var parentNode = node.parent().closest('.item_for_node').required();
	
	$.ajax({
		type: 'get',
		url: (state == 'new') ? form.attr('action').replace(/\?/, '/new?') : (node.attr('oc\:url') + '/edit'),
		data: form.serialize() + '&' + $.param({'add[prop_type]': addType}),
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		if (state == 'new')
		{
			var list = node.parent('.list').required();
			
			//var newBody = node.replaceWith(responseData); // possible?
			node.replaceWith(responseData);
			
			var newBody = list.children('.item_for_node:last').find('.new.body').required();
			
			newBody.find('.note.prop').find('textarea').elastic();
			
			showFill(newBody);
			
			formFocus(newBody.find('form').required());
		}
		else if (state == 'edit')
		{
			var showBody = node.children('.show.body').required();
			var editBody = showBody.siblings('.edit.body').required();
			
			//var editBody = node.replaceWith(responseData); // possible?
			editBody.replaceWith(responseData);
			
			var editBody = showBody.siblings('.edit.body').required();
			
			editBody.find('.note.prop').find('textarea').elastic();
			
			showFill(editBody);
			formFocus(editBody.find('form').required());
		}
	}
	
	function handleError(xhrObj, errStr, expObj) {
		node.find('.body:first').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}

$(function() {
	$('#add-bar a.add.text'		).live('click', function() { badgeAdd(this, 'text'		); return false; });
	$('#add-bar a.add.check'	).live('click', function() { badgeAdd(this, 'check'		); return false; });
	$('#add-bar a.add.note'		).live('click', function() { badgeAdd(this, 'note'		); return false; });
	$('#add-bar a.add.priority'	).live('click', function() { badgeAdd(this, 'priority'	); return false; });
	$('#add-bar a.add.tag'		).live('click', function() { badgeAdd(this, 'tag'		); return false; });
	$('#add-bar a.add.time'		).live('click', function() { badgeAdd(this, 'time'		); return false; });
	$('#add-bar a.add.pile-ref'	).live('click', function() { badgeAdd(this, 'pile-ref'	); return false; });
});


function badgeRemove(link) {
	var deleteField = $(link).siblings('input[type=hidden]').required();
	deleteField.val(1);
	
	var node = $(link).closest('.item_for_node').required();
	
	var state;
	if (node.children('.new')[0])
		state = 'new';
	else if (node.children('.edit')[0])
		state = 'edit';
	else if (typeof(console) != 'undefined' && typeof(console.assert) != 'undefined')
		console.assert('invalid state');
	
	var form = node.find('form').required();
	var parentNode = node.parent().closest('.item_for_node').required();
	
	$.ajax({
		type: 'get',
		url: (state == 'new') ? form.attr('action').replace(/\?/, '/new?') : (node.attr('oc\:url') + '/edit'),
		data: form.serialize(),
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		if (state == 'new')
		{
			var list = node.parent('.list').required();
			
			//var newBody = node.replaceWith(responseData); // possible?
			node.replaceWith(responseData);
			
			var newBody = list.children('.item_for_node:last').find('.new.body').required();
			
			newBody.find('.note.prop').find('textarea').elastic();
			
			showFill(newBody);
			
			formFocus(newBody.find('form').required());
		}
		else if (state == 'edit')
		{
			var showBody = node.children('.show.body').required();
			var editBody = showBody.siblings('.edit.body').required();
			
			//var editBody = node.replaceWith(responseData); // possible?
			editBody.replaceWith(responseData);
			
			var editBody = showBody.siblings('.edit.body').required();
			
			editBody.find('.note.prop').find('textarea').elastic();
			
			showFill(editBody);
			formFocus(editBody.find('form').required());
		}
	}
	
	function handleError(xhrObj, errStr, expObj) {
		node.find('.body:first').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}

$(function() {
	$('.sub-line a.remove').live('click', function() { badgeRemove(this); return false; });
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
