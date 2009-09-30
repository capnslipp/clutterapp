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


function expandActionBar(nodeID) {
	// hide everything else first
	elementsForNodeModels('item-action_for').find('.buttons').hide();
	elementsForNodeModels('item-action_for').find('.widget.expanded').hide();
	elementsForNodeModels('item-action_for').find('.widget.collapsed').show();
	elementsForNodeModels('item-new_for').hide();
	//$('.initially-hidden').hide();
	
	
	elementForNodeModel(nodeID, 'item-action_for').find('.buttons').show();
	elementForNodeModel(nodeID, 'item-action_for').find('.widget.expanded').show();
	elementForNodeModel(nodeID, 'item-action_for').find('.widget.collapsed').hide();
}


function collapseActionBar(nodeID) {
 	elementForNodeModel(nodeID, 'item-action_for').find('.buttons').hide();
 	elementForNodeModel(nodeID, 'item-action_for').find('.widget.expanded').hide();
 	elementForNodeModel(nodeID, 'item-action_for').find('.widget.collapsed').show();
	hideItemNewBar(nodeID);
}


function toggleItemNewBar(nodeID) {
	elementForNodeModel(nodeID, 'item-new_for').toggle();
}


function hideItemNewBar(nodeID) {
	elementForNodeModel(nodeID, 'item-new_for').hide();
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


$(function() {
	var actionButtons = $('.action.buttons');
	actionButtons.find('.move.out')
		.click(function() { return nodeItemMove($(this).closest('.node'), 'out'); });
	actionButtons.find('.move.up')
		.click(function() { return nodeItemMove($(this).closest('.node'), 'up'); });
	actionButtons.find('.move.down')
		.click(function() { return nodeItemMove($(this).closest('.node'), 'down'); });
	actionButtons.find('.move.in')
		.click(function() { return nodeItemMove($(this).closest('.node'), 'in'); });
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
