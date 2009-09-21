// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


var OrgClut = {};

JOIN = '_'
NEW = 'new'

function nodeDomClass(prefix) {
	if (prefix == undefined)
		return 'node'
	else
		return prefix + JOIN + 'node'
}


function nodeDomID(recordID, prefix) {
	if (recordID != '')
		return nodeDomClass(prefix) + JOIN + recordID
	else
		return (prefix == undefined) ? nodeDomClass(NEW) : nodeDomClass(prefix)
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


function expandActionBar(nodeID) {
	// hide everything else first
	$('.' + nodeDomClass('item-action')).children('.buttons').hide();
	$('.' + nodeDomClass('item-action')).children('.widget').show();
	$('.' + nodeDomClass('item-new')).hide();
	
 	$('#' + nodeDomID(nodeID, 'item-action')).children('.widget').hide();
 	$('#' + nodeDomID(nodeID, 'item-action')).children('.buttons').show();
}


function collapseActionBar(nodeID) {
 	$('#' + nodeDomID(nodeID, 'item-action')).children('.buttons').hide();
 	$('#' + nodeDomID(nodeID, 'item-action')).children('.widget').show();
	hideItemNewBar(nodeID);
}


function toggleItemNewBar(nodeID) {
	$('#' + nodeDomID(nodeID, 'item-new')).toggle();
}


function hideItemNewBar(nodeID) {
	$('#' + nodeDomID(nodeID, 'item-new')).hide();
}



OrgClut.kPageMinWidth = 320;
OrgClut.writePageMinWidthAdjustment = function() {
	// if the screen's width is smaller than the page's width (i.e. a zoomable mobile device like the iPhone)
	if (window.screen.width < window.innerWidth) {
		// set the meta-data to the larger of the device's width or the minimum the site needs!
		
		newWidth = window.screen.width;
		if (newWidth < OrgClut.kPageMinWidth)
			newWidth = OrgClut.kPageMinWidth;
		
		// will write the meta tag right into the <head/>
		document.write('<meta name="viewport" content="width=' + newWidth + '"/>');
	}
}
OrgClut.writePageMinWidthAdjustment();