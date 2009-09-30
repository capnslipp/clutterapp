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
	return false;
	
	
	function handleSuccess(prop, responseData) {
		showFill( prop.parent() );
		
		prop
			.replaceWith(responseData);
		
		editFormFocus(prop.find('form'));
	}
	
	function handleError(prop, xhrObj, errStr, expObj) {
		prop.closest('.body')
			.effect('highlight', {color: '#910'}, 2000);
	}
}

$(function() {
	$('.show.prop').live('click', function() {
		return editFormShow($(this));
	});
});


function editFormSubmit(form) {
	$.ajax({
		type: form.attr('method'),
		url: form.attr('action'),
		data: form.formSerialize(false),
		dataType: 'html',
		success: function(responseData) { handleSuccess(form, responseData); }, // return needed?
		error: function(xhrObj, errStr, expObj) { handleError(form, xhrObj, errStr, expObj); } // return needed?
	});
	return false;
	
	
	function handleSuccess(form, responseData) {
		var prop = form.closest('.edit.prop');
		
		hideFill( prop.parent() );
		
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
		return editFormSubmit($(this));
	});
});



function nodeItemCreate(parentNode, type) {
	$.ajax({
		type: 'post',
		data: {type: type, parent_id: nodeIDOfItem(parentNode)},
		url: parentNode.closest('.pile').attr('oc\:nodesUrl'),
		dataType: 'script',
		success: function(responseData) { handleSuccess(parentNode, responseData); }, // return needed?
		error: function(xhrObj, errStr, expObj) { handleError(parentNode, xhrObj, errStr, expObj); } // return needed?
	});
	return false;
	
	
	function handleSuccess(parentNode, responseData) {
		// nothing for now; @todo: move the element here
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
		success: function(responseData) { handleSuccess(node, responseData); }, // return needed?
		error: function(xhrObj, errStr, expObj) { handleError(node, xhrObj, errStr, expObj); } // return needed?
	});
	return false;
	
	
	function handleSuccess(node, responseData) {
		// nothing for now; @todo: move the element here
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
		dataType: 'script',
		success: function(responseData) { handleSuccess(node, responseData); }, // return needed?
		error: function(xhrObj, errStr, expObj) { handleError(node, xhrObj, errStr, expObj); } // return needed?
	});
	return false;
	
	
	function handleSuccess(node, responseData) {
		// nothing for now; @todo: move the element here
	}
	
	function handleError(node, xhrObj, errStr, expObj) {
		node.find('.body:first')
			.effect('highlight', {color: '#910'}, 2000);
	}
}


$(function() {
	$('.action.stub .widget.collapsed a').live('click', function() {
		return expandActionBar($(this).closest('.item_for_node'));
	});
	
	$('#action-bar .widget.expanded a')
		.click(function() { return collapseActionBar(); })
	
	var actionButtons = $('#action-bar .buttons');
	actionButtons.find('a.move.out')
		.click(function() { return nodeItemMove($(this).closest('.item_for_node'), 'out'); });
	actionButtons.find('a.move.up')
		.click(function() { return nodeItemMove($(this).closest('.item_for_node'), 'up'); });
	actionButtons.find('a.move.down')
		.click(function() { return nodeItemMove($(this).closest('.item_for_node'), 'down'); });
	actionButtons.find('a.move.in')
		.click(function() { return nodeItemMove($(this).closest('.item_for_node'), 'in'); });
	
	actionButtons.find('a.delete')
		.click(function() { return nodeItemDelete($(this).closest('.item_for_node')); });
	
	actionButtons.find('a.toggle.new-bar')
		.click(function() { return toggleItemNewBar($(this).closest('.item_for_node')); });
	
	
	$('#new-bar .widget.expanded a')
		.click(function() { return hideItemNewBar(); })
	
	var newButtons = $('#new-bar .buttons');
	newButtons.find('a.new.text')
		.click(function() { return nodeItemCreate($(this).closest('.item_for_node'), 'text'); })
	newButtons.find('a.new.check')
		.click(function() { return nodeItemCreate($(this).closest('.item_for_node'), 'check'); })
	newButtons.find('a.new.note')
		.click(function() { return nodeItemCreate($(this).closest('.item_for_node'), 'note'); })
	newButtons.find('a.new.priority')
		.click(function() { return nodeItemCreate($(this).closest('.item_for_node'), 'priority'); })
	newButtons.find('a.new.tag')
		.click(function() { return nodeItemCreate($(this).closest('.item_for_node'), 'tag'); })
	newButtons.find('a.new.time')
		.click(function() { return nodeItemCreate($(this).closest('.item_for_node'), 'time'); })
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
