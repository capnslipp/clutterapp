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



function showFill() {
	$('#fill').fadeIn(500);
}

function hideFill() {
	$('#fill').fadeOut(333);
}


function editFormFocus(form) {
	form
		.css('position', 'relative')
		.css('z-index', 1000);
	
	form.children('.field:first')
		.focus();
	
	showFill();
}

function editFormSubmit(form) {
	$.ajax({
		type: form.attr('method'),
		url: form.attr('action'),
		data: form.formSerialize(false),
		dataType: 'html',
		success: function(responseData) { return editFormSuccess(form, responseData); }, // return needed?
		error: function(xhrObj, errStr, expObj) { return editFormError(form, xhrObj, errStr, expObj); } // return needed?
	});
	
	return false;
}

$(function() {
	$('form.edit_node').livequery('submit', function() {
		return editFormSubmit( $(this) );
	});
});

function editFormSuccess(form, responseData) {
	form.closest('.edit.prop')
		.replaceWith(responseData);
	
	hideFill();
	
	return false; // needed?
}

function editFormError(form, xhrObj, errStr, expObj) {
	form.closest('.edit.prop')
		.effect('highlight', {color: '#910'}, 2000);
	
	editFormFocus(form);
	
	return false; // needed?
}



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
