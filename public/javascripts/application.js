// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults



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



function showFill(modalElement) {
	if (!$('#fill').is(':visible')) {
		if (modalElement) {
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
	
		if (modalElement) {
			modalElement
				.css('position', modalElement.attr('oc\:origPosition'))
				.css('z-index', 0);
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
	
	
	function handleSuccess(prop, responseData) {
		var body = prop.parent('.body');
		
		showFill(body);
		
		prop
			.replaceWith(responseData);
		
		editFormFocus(body.find('form'));
	}
	
	function handleError(prop, xhrObj, errStr, expObj) {
		prop.closest('.body')
			.effect('highlight', {color: '#910'}, 2000);
	}
}

$(function() {
	$('.item_for_node > .body:has(.show.prop)').live('click', function() {
		editFormShow($(this).children('.show.prop')); return false;
	});
	$('.item_for_node > .body').live('mouseover', function() {
		$(this).css('background', '#fff2f0');
	});
	$('.item_for_node > .body').live('mouseout', function() {
		$(this).css('background', 'transparent');
	});
});


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
		var prop = form.closest('.edit.prop');
		
		hideFill( prop.parent('.body') );
		
		prop
			.replaceWith(responseData);
	}
	
	function handleError(form, xhrObj, errStr, expObj) {
		form.closest('.edit.prop').closest('.body')
			.effect('highlight', {color: '#910'}, 2000);
		
		editFormFocus(form);
	}
}

$(function() {
	$('form.edit_node').live('submit', function() {
		editFormSubmit($(this)); return false;
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
		
		parentNode.children('.list').children('.li.node:last')
			.effect('highlight', 2000);
	}
	
	function handleError(parentNode, xhrObj, errStr, expObj) {
		parentNode.find('#new-bar:first')
			.effect('highlight', {color: '#910'}, 2000);
	}
}



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



kPageMinWidth = 320;
function writePageMinWidthAdjustment() {
	// if the screen's width is smaller than the page's width (i.e. a zoomable mobile device like the iPhone)
	if (window.screen.width < window.innerWidth) {
		// set the meta-data to the larger of the device's width or the minimum the site needs!
		
		newWidth = window.screen.width;
		if (newWidth < kPageMinWidth)
			newWidth = kPageMinWidth;
		
		// will write the meta tag right into the <head/>
		document.write('<meta name="viewport" content="width=' + newWidth + '"/>');
	}
}
writePageMinWidthAdjustment();
