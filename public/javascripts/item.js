// ClutterApp item view functionality JS


var JOIN = '_';
var NEW = 'new';

var kSlowTransitionDuration =		375;
var kDefaultTransitionDuration =	250;
var kQuickTransitionDuration =		125;


// unused
//function classForNodeModels(prefix) {
//	if (prefix == undefined)
//		return 'node'
//	else
//		return prefix + JOIN + 'node'
//}
//
//
//function idForNodeModel(recordID, prefix) {
//	if (recordID != '')
//		return classForNodeModels(prefix) + JOIN + recordID
//	else
//		return (prefix == undefined) ? classForNodeModels(NEW) : classForNodeModels(prefix)
//}


function nodeIDOfItem(node) {
	var nodeID = node.getAttr('id');
	
	if (nodeID.match(/base_node_/))
		return nodeID.substring('base_node_'.length);
	else if (nodeID.match(/node_/))
		return nodeID.substring('node_'.length);
	else
		return null;
}



function expandActionBar(node) {
	if (ClutterApp.fsm.isBusy())
		return;
	
	node.required();
	
	collapseActionBar();
	
	var nodeBody = node.children('.body').required();
	
	nodeBody.children('.action.stub').hide();
	
	nodeBody.addClass('active');
	
	if (!nodeBody.find('#action-bar')[0])
		$('#action-bar').prependTo(nodeBody);
	
	if (node.hasClass('pile'))
		$('#action-bar > .buttons > a:not(.new)').hide();
	
	// since it may be initially-hidden
	safeShow($('#action-bar'));
	
	if (!node.hasClass('pile')) {
		node.activateReparentDraggable();
		node.closest('ul.item-list').required().activateReorderSortable();
	}
}

function collapseActionBar() {
	var node = $('#action-bar').closest('.item').required();
	var nodeBody = node.children('.body').required();
	
	
	node.deactivateReparentDraggable();
	node.closest('ul.item-list').deactivateReorderSortable();
	
	
	$('#action-bar').hide();
	
	nodeBody.children('.action.stub').show();
	
	nodeBody.removeClass('active');
	
	
	$('#action-bar').appendTo($('.pile:first')); // in case the parent item gets deleted
	
	
	$('#action-bar > .buttons > a').show();
}

$(function() {
	$('li.item > .show.body > .cont').live('click', function() {
		expandActionBar($(this).closest('li.item')); return false;
	});
	$('section.pile.item > .body > .header').live('click', function() {
		expandActionBar($(this).closest('section.pile.item')); return false;
	});
});

$(function() {
	$('li.item > .show.body > .action.stub .widget.collapsed a').live('click', function() {
		expandActionBar($(this).closest('li.item')); return false;
	});
	$('section.pile.item > .body > .action.stub .widget.collapsed a').live('click', function() {
		expandActionBar($(this).closest('section.pile.item')); return false;
	});
	
	$('#action-bar .widget.expanded a').click(function() {
		if (!ClutterApp.fsm.isBusy())
			collapseActionBar();
		
		return false;
	});
});



function formFocus(form) {
	form.find('.field:first').required()
		.focus();
}



function itemNew(parentNode, type, prevSiblingNode, dupPrev) {
	if (!ClutterApp.fsm.changeAction('itemNew', 'load'))
		return;
	
	
	parentNode.filter('.item').required();
	
	collapseActionBar();
	parentNode.showProgressOverlay();
	ClutterApp.fill.show();
	
	var prevSiblingNodeID = prevSiblingNode ? nodeIDOfItem(prevSiblingNode) : '';
	
	$.ajax({
		type: 'get',
		url: parentNode.closest('.pile').getAttr('oc\:nodes-url') + '/new',
		data: { 'node[prop_type]': type, 'node[parent_id]': nodeIDOfItem(parentNode), prev_sibling_id: prevSiblingNodeID, dup_prev: (dupPrev || '') },
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		hideProgressOverlay();
		
		var list = parentNode.children('.item-list').required();
		
		if (!prevSiblingNode) {
			list.prepend(responseData);
			var newNode = list.children('li.item:first').require('.new');
		} else {
			prevSiblingNode.filter('.item').required();
			prevSiblingNode.after(responseData);
			var newNode = prevSiblingNode.next('li.item').require('.new');
		}
		
		var newBody = newNode.find('.new.body').required();
		
		var startScaleX = 0.95; var endScaleX = 1.0;
		var startScaleY = 0.0; var endScaleY = 1.0;
		newBody.setCSS({
			opacity: 0.0,
			        'transform-origin': '50% 25%',
			   '-moz-transform-origin': '50% 25%',
			'-webkit-transform-origin': '50% 25%'
		}).animate(
			{opacity: 1.0},
			{
				duration: kDefaultTransitionDuration,
				easing: 'easeOutQuad',
				step: function(ratio) {
					var scaleValX = (endScaleX - startScaleX) * ratio + startScaleX;
					var scaleValY = (endScaleY - startScaleY) * ratio + startScaleY;
					$(this).setCSS({
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
					})
				}
			}
		);
		
		newBody.find('.note.prop').find('textarea').elastic();
		
		ClutterApp.fill.show(newBody);
		
		var newBodyForm = newBody.find('form').required();
		formFocus(newBodyForm.required());
		
		
		ClutterApp.fsm.finishState('itemNew', 'load');
		ClutterApp.fsm.addContext('itemNew', null, newNode);
	}
	
	function handleError(xhrObj, errStr, expObj) {
		hideProgressOverlay();
		ClutterApp.fill.hide();
		
		parentNode.children('.show.body')
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000); // @todo: fix
		
		
		ClutterApp.fsm.finishAction('itemNew', 'load');
	}
}
	
$(function() {
	var actionButtons = $('#action-bar > .buttons > a.new').required()
		.click(function() { itemNew($(this).closest('.item'), 'text'); return false; });
});



function itemNewCancel(buttonOrNode) {
	if (!ClutterApp.fsm.changeState('itemNew', 'cancel'))
		return;
	
	
	var node = buttonOrNode.closest('.item').required();
	var newBody = node.children('.new.body').required();
	var form = newBody.children('form.new_node').required();
	
	form.find('input[type=submit], input[type=button]').required().setAttr('disabled', 'disabled');
	
	ClutterApp.fill.hide();
		
	var startScaleX = 1.25; var endScaleX = 1.0;
	var startScaleY = 1.25; var endScaleY = 1.0;
	newBody.setCSS({
		opacity: 1.0,
		        'transform-origin': '50% 25%',
		   '-moz-transform-origin': '50% 25%',
		'-webkit-transform-origin': '50% 25%'
	}).animate(
		{opacity: 0.0},
		{
			duration: kSlowTransitionDuration,
			easing: 'easeInQuad',
			step: function(ratio) {
				var scaleValX = (endScaleX - startScaleX) * ratio + startScaleX;
				var scaleValY = (endScaleY - startScaleY) * ratio + startScaleY;
				$(this).setCSS({
					        'transform': 'scale('+scaleValX+', '+scaleValY+')',
					   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
					'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
				})
			},
			complete: function() {
				newBody.closest('li.item').required().remove();
				
				ClutterApp.fsm.finishAction('itemNew', 'cancel');
			}
		}
	);
}

$(function() {
	$('form.new_node input.cancel').live('click', function() {
		itemNewCancel($(this)); return false;
	});
	
	$().keydown(function(e) {
		if (e.which != kEscapeKeyCode)
			return;
		
		if (ClutterApp.fsm.action() != 'itemNew' || ClutterApp.fsm.isStateBusy())
			return;
		
		itemNewCancel( ClutterApp.fsm.context().required() );
	});
});



function itemCreate(newNode, another) {
	if (!ClutterApp.fsm.changeState('itemNew', 'done'))
		return;
	
	
	var form = newNode.find('form').required();
	
	form.find('input[type=submit], input[type=button]').required().setAttr('disabled', 'disabled');
	
	var newBody = form.closest('.new.body').required();
	var newItem = newBody.closest('li.item').required();
	
	newBody.showProgressOverlay();
	
	$.ajax({
		type: form.getAttr('method'), // 'post'
		url: form.getAttr('action'),
		data: form.serialize(),
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		newItem.after(responseData);
		
		var createdItem = newItem.next('li.item').required();
		createdItem.hide();
		createdItem.applyReparentDroppability();
		
		var startScaleX = 0.95; var endScaleX = 1.0;
		var startScaleY = 0.75; var endScaleY = 1.0;
		newBody.setCSS({
			opacity: 1.0,
			        'transform-origin': '50% 25%',
			   '-moz-transform-origin': '50% 25%',
			'-webkit-transform-origin': '50% 25%'
		}).animate(
			{opacity: 0.0},
			{
				duration: kDefaultTransitionDuration,
				easing: 'easeInQuad',
				step: function(ratio) {
					var scaleValX = (endScaleX - startScaleX) * ratio + startScaleX;
					var scaleValY = (endScaleY - startScaleY) * ratio + startScaleY;
					$(this).setCSS({
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
					});
				},
				complete: function() {
					ClutterApp.fill.hide();
					
					newItem.remove();
					createdItem.fadeIn(kDefaultTransitionDuration);
					
					ClutterApp.fsm.finishAction('itemNew', 'done');
					
					
					if (another) {
						var parentItem = createdItem.parent().closest('.item');
						itemNew(parentItem, 'text', createdItem, true);
					}
				}
			}
		);
	}
	
	function handleError(xhrObj, errStr, expObj) {
		hideProgressOverlay();
		
		newBody.required()
			.stop(true, true)
			.fadeIn(kQuickTransitionDuration, function()
		{
			newBody.find('.cont').required()
				.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		});
		
		form.find('input[type=submit], input[type=button]').required().removeAttr('disabled');
		formFocus(form);
		
		
		ClutterApp.fsm.finishState('itemNew', 'done');
	}
}

$(function() {
	$('form.new_node').live('submit', function() {
		itemCreate($(this).closest('.item')); return false;
	});
	
	$('form.new_node input.another').live('click', function() {
		itemCreate($(this).closest('.item'), true); return false;
	});
	
	$().keydown(function(e) {
		if (String.fromCharCode(e.which) != '\r')
			return;
		
		if (ClutterApp.fsm.action() != 'itemNew' || ClutterApp.fsm.isStateBusy())
			return;
		
		if (e.shiftKey || e.ctrlKey || e.altKey || e.metaKey)
			itemCreate( ClutterApp.fsm.context().required(), true );
	});
});



function itemEdit(link) {
	if (!ClutterApp.fsm.changeAction('itemEdit', 'load'))
		return;
	
	
	var showBody = $(link).closest('.show.body').required();
	
	collapseActionBar();
	showBody.showProgressOverlay();
	ClutterApp.fill.show();
	
	$.ajax({
		type: 'get',
		url: showBody.closest('.item').getAttr('oc\:url') + '/edit',
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		hideProgressOverlay();
		
		showBody.before(responseData);
		
		var editNode = showBody.closest('li.item').required();
		var editBody = showBody.siblings('.edit.body').required();
		
		var startScaleX = 0.95; var endScaleX = 1.0;
		var startScaleY = 0.75; var endScaleY = 1.0;
		editBody.setCSS({
			opacity: 0.0,
			        'transform-origin': '50% 25%',
			   '-moz-transform-origin': '50% 25%',
			'-webkit-transform-origin': '50% 25%'
		}).animate(
			{opacity: 1.0},
			{
				duration: kDefaultTransitionDuration,
				easing: 'easeOutQuad',
				step: function(ratio) {
					var scaleValX = (endScaleX - startScaleX) * ratio + startScaleX;
					var scaleValY = (endScaleY - startScaleY) * ratio + startScaleY;
					$(this).setCSS({
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
					})
				}
			}
		);
		
		editBody.find('.note.prop').find('textarea').elastic();
		
		ClutterApp.fill.show(editBody);
		formFocus(editBody.find('form').required());
		
		
		ClutterApp.fsm.finishState('itemEdit', 'load');
		ClutterApp.fsm.addContext('itemEdit', null, editNode);
	}
	
	function handleError(xhrObj, errStr, expObj) {
		hideProgressOverlay();
		ClutterApp.fill.hide();
		
		showBody
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		
		
		ClutterApp.fsm.finishAction('itemEdit', 'load');
	}
}

$(function() {
	$('li.item > .show.body > .cont').live('dblclick', function() {
		itemEdit(this); return false;
	});
	$('#action-bar > .buttons > a.edit').click(function() {
		itemEdit(this); return false;
	});
});



function itemEditCancel(buttonOrNode) {
	if (!ClutterApp.fsm.changeState('itemEdit', 'cancel'))
		return;
	
	var node = buttonOrNode.closest('.item').required();
	var editBody = node.children('.edit.body').required();
	var form = editBody.children('form.edit_node').required();
	
	form.find('input[type=submit], input[type=button]').required().setAttr('disabled', 'disabled');
	
	ClutterApp.fill.hide();
	
	var startScale = 1.25; var endScale = 1.0;
	editBody.setCSS({
		opacity: 1.0,
		        'transform-origin': '50% 50%',
		   '-moz-transform-origin': '50% 50%',
		'-webkit-transform-origin': '50% 50%'
	}).animate(
		{opacity: 0.0},
		{
			duration: kSlowTransitionDuration,
			easing: 'easeInQuad',
			step: function(ratio) {
				var scaleVal = (endScale - startScale) * ratio + startScale;
				$(this).setCSS({
					        'transform': 'scale('+scaleVal+')',
					   '-moz-transform': 'scale('+scaleVal+')',
					'-webkit-transform': 'scale('+scaleVal+')'
				})
			},
			complete: function() {
				editBody.remove();
				
				ClutterApp.fsm.finishAction('itemEdit', 'cancel');
			}
		}
	);
}

$(function() {
	$('form.edit_node input.cancel').live('click', function() {
		itemEditCancel($(this)); return false;
	});
	
	$().keydown(function(e) {
		if (e.which != kEscapeKeyCode)
			return;
		
		if (ClutterApp.fsm.action() != 'itemEdit' || ClutterApp.fsm.isStateBusy())
			return;
		
		itemEditCancel( ClutterApp.fsm.context().required() );
	});
});



function itemUpdate(form, another) {
	if (!ClutterApp.fsm.changeState('itemEdit', 'done'))
		return;
	
	
	form.required();
	
	form.find('input[type=submit], input[type=button]').required().setAttr('disabled', 'disabled');
	
	var editBody = form.closest('.edit.body').required();
	var showBody = editBody.siblings('.show.body').required();
	
	editBody.showProgressOverlay();
	
	$.ajax({
		type: form.getAttr('method'), // 'post' (PUT)
		url: form.getAttr('action'),
		data: form.serialize(),
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		showBody.replaceWith(responseData);
		// showBody ref no longer valid from this point on
		editBody.closest('li.item').required().applyReparentDroppability();
		
		
		var startScaleX = 0.95; var endScaleX = 1.0;
		var startScaleY = 0.75; var endScaleY = 1.0;
		editBody.setCSS({
			opacity: 1.0,
			        'transform-origin': '50% 25%',
			   '-moz-transform-origin': '50% 25%',
			'-webkit-transform-origin': '50% 25%'
		}).animate(
			{opacity: 0.0},
			{
				duration: kDefaultTransitionDuration,
				easing: 'easeInQuad',
				step: function(ratio) {
					var scaleValX = (endScaleX - startScaleX) * ratio + startScaleX;
					var scaleValY = (endScaleY - startScaleY) * ratio + startScaleY;
					$(this).setCSS({
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
					})
				},
				complete: function() {
					ClutterApp.fill.hide();
					
					showBody = editBody.siblings('.show.body').required();
					editBody.remove();
					
					ClutterApp.fsm.finishAction('itemEdit', 'done');
					
					
					if (another) {
						var updatedNode = showBody.closest('.item');
						var parentNode = updatedNode.parent().closest('.item');
						itemNew(parentNode, 'text', updatedNode, true);
					}
				}
			}
		);
	}
	
	function handleError(xhrObj, errStr, expObj) {
		hideProgressOverlay();
		
		editBody.required()
			.stop(true, true)
			.fadeIn(kQuickTransitionDuration, function()
		{
			editBody.find('.cont').required()
				.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		});
		
		form.find('input[type=submit], input[type=button]').required().removeAttr('disabled');
		formFocus(form);
		
		
		ClutterApp.fsm.finishState('itemEdit', 'done');
	}
}

$(function() {
	$('form.edit_node').live('submit', function() {
		itemUpdate($(this)); return false;
	});
	
	$('form.edit_node input.another').live('click', function() {
		itemUpdate($(this).closest('form'), true); return false;
	});
	
	$().keydown(function(e) {
		if (String.fromCharCode(e.which) != '\r')
			return;
		
		if (ClutterApp.fsm.action() != 'itemEdit' || ClutterApp.fsm.isStateBusy())
			return;
		
		if (e.shiftKey || e.ctrlKey || e.altKey || e.metaKey)
			itemUpdate( ClutterApp.fsm.context().required().find('form'), true );
	});
});



function itemDelete(node) {
	if (!ClutterApp.fsm.changeAction('itemDelete', 'load'))
		return;
	
	
	$.ajax({
		type: 'post',
		url: node.getAttr('oc\:url'),
		data: {_method: 'delete'},
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		collapseActionBar();
		
		
		var endScaleX = 0.95;
		var endScaleY = 0.25;
		var startHeight = node.height();
		node.setCSS({
			opacity: 1.0,
			overflow: 'visible',
			        'transform-origin': '50% 0%',
			   '-moz-transform-origin': '50% 0%',
			'-webkit-transform-origin': '50% 0%',
		}).animate(
			{ opacity: 0.0 },
			{
				duration: kSlowTransitionDuration,
				easing: 'easeOutQuad',
				step: function(opacity) {
					var ratio = opacity;
					
					var scaleValX = (1.0 - endScaleX) * ratio + endScaleX;
					var scaleValY = (1.0 - endScaleY) * ratio + endScaleY;
					var heightVal = startHeight * ratio;
					$(this).setCSS({
						height: heightVal,
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
					})
				},
				complete: function() {
					node.remove();
					
					
					ClutterApp.fsm.finishAction('itemDelete', 'load');
				}
			}
		);
	}
	
	function handleError(xhrObj, errStr, expObj) {
		node.find('.body:first .cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}
	
$(function() {
	var actionButtons = $('#action-bar .buttons').required();
	
	actionButtons.find('a.delete').click(function() {
		if (confirm("Are you sure?\n\nThis will delete this item and all of its sub-items."))
			itemDelete($(this).closest('li.item'));
		
		return false;
	});
});



//$(function() {
//	$().applyReorderability();
//});

//jQuery.fn.applyReorderability = function() {
//	var nodeLists = $(this).search('ul.item-list');
//	
//	nodeLists.activateReorderSortable();
//	
//	return this;
//}

jQuery.fn.activateReorderSortable = function() {
	var disabled = this.filter('.ui-sortable-disabled');
	disabled.sortable('enable');
	
	var alreadySetup = this.filter('.ui-sortable');
	alreadySetup.sortable('refresh');
	
	var toSetup = this.not('.ui-sortable');
	toSetup.setupReorderSortable();
	
	return this;
}

jQuery.fn.deactivateReorderSortable = function() {
	var alreadySetup = this.filter('.ui-sortable');
	alreadySetup.sortable('disable');
	
	return this;
}

jQuery.fn.setupReorderSortable = function() {
	this.sortable({
		axis: 'y',
		containment: '#active-sorting-container',
		tolerance: 'pointer',
		handle: '> .show.body > #action-bar .move.reorder',
		helper: helper,
		opacity: 0.5,
		revert: true,
		scroll: true,
		start: start,
		stop: stop
	});
	return this;
	
	
	var elementHeight;
	var origPrevSiblingID;
	
	function helper(event, element) {
		// save the height for future use
		elementHeight = $(element).height();
		
		earlyStart(event, element);
		
		var helper = $(element).clone();
		//helper.setCSS({ height: 0 });
		return helper[0];
	}
	
	function earlyStart(event, element) {
		element = $(element);
		var list = element.parent('ul.item-list').required();
		
		var bounds = {
			top: list.position().top,
			height: list.height(),
			left: list.position().left,
			width: list.width(),
		};
		list.wrap('<div id="active-sorting-container"></div>');
		
		var containmentPadding = (elementHeight / 2) + 32; // an extra bit for the difference between the middle of the item and the drag handle
		$('#active-sorting-container').required().setCSS({
			margin: -containmentPadding - 1,
			border: '1px solid transparent', // this is necessary for the expaned container to work for some odd reasone
		});
		list.setCSS({margin: containmentPadding});
	}
	
	function start(event, ui) {
		var list = ui.item.parent('ul.item-list').required();
		ClutterApp.fill.show(list);
		list.addClass('active');
		
		var origPrevSibling = ui.item.prev('li.item');
		origPrevSiblingID = origPrevSibling[0] ? nodeIDOfItem(origPrevSibling) : '';
		
		var placeholder = ui.placeholder.required();
		placeholder.prepend('<div class="back"></div> <div class="cont"></div>');
	}
	
	function stop(event, ui) {
		var list = ui.item.parent('ul.item-list').required();
		
		$('#active-sorting-container').required().replaceWith(
			$('#active-sorting-container > ul.item-list').required()
		);
		list.removeAttr('style'); // clear out unnecessary styles
		
		// @todo: optimize so this isn't being done twice
		var prevSibling = ui.item.prev('li.item');
		var prevSiblingID = prevSibling[0] ? nodeIDOfItem(prevSibling) : '';
		
		// only if the prevSibling has changed
		if (prevSiblingID != origPrevSiblingID) {
			itemReorder(ui.item);
		} else {
			ClutterApp.fill.hide(list);
			list.removeClass('active');
		}
		
		$(this).removeAttr('style'); // clear out unnecessary styles
	}
}

function itemReorder(node) {
	if (!ClutterApp.fsm.changeAction('itemReorder', 'load')) {
		handleError(); // return the item back for now, since we have no way to prevent the drag from starting
		return;
	}
	
	
	node.required();
	
	var list = node.parent('ul.item-list').required();
	
	list.showProgressOverlay();
	
	var prevSibling = node.prev('li.item');
	var prevSiblingID = prevSibling[0] ? nodeIDOfItem(prevSibling) : '';
	
	$.ajax({
		type: 'post',
		url: node.getAttr('oc\:url') + '/reorder',
		data: {_method: 'put', prev_sibling_id: prevSiblingID},
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		hideProgressOverlay();
		
		ClutterApp.fill.hide(list);
		list.removeClass('active');
		
		
		ClutterApp.fsm.finishAction('itemReorder', 'load');
	}
	
	function handleError(xhrObj, errStr, expObj) {
		hideProgressOverlay();
		
		node.find('.body:first .cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		
		
		ClutterApp.fsm.finishAction('itemReorder', 'load');
	}
}



jQuery.fn.activateReparentDraggable = function() {
	var disabled = this.filter('.ui-draggable-disabled');
	disabled.draggable('enable');
	
	var toSetup = this.not('.ui-draggable');
	toSetup.setupReparentDraggable();
	
	return this;
}

jQuery.fn.deactivateReparentDraggable = function() {
	var alreadySetup = this.filter('.ui-draggable');
	alreadySetup.draggable('disable');
	
	return this;
}

// this is done when the actionbar opens
jQuery.fn.setupReparentDraggable = function() {
	this.draggable({
		axis: 'y',
		cancel: '.body > .cont, .body > .bullet, .body > .action.stub, .edit.body, .new.body',
		handle: '#action-bar a.move.reparent',
		opacity: 0.5,
		revert: 'invalid',
		scope: 'item-reparent',
		scroll: true,
		//zIndex: 500,
		start: function() { $(this).setCSS('z-index', 500); },
		stop: function() { $(this).setCSS('z-index', ''); },
	});
	return this;
}



$(function() {
	$().applyReparentDroppability();
});

jQuery.fn.applyReparentDroppability = function() {
	$(this).search('li.item > .show.body, section.pile.item > .body').activateReparentDroppable();
	return this;
}

jQuery.fn.activateReparentDroppable = function() {
	var disabled = this.filter('.ui-droppable-disabled');
	disabled.droppable('enable');
	
	var toSetup = this.not('.ui-droppable');
	toSetup.setupReparentDroppable();
	
	return this;
}

jQuery.fn.deactivateReparentDroppable = function() {
	var alreadySetup = this.filter('.ui-droppable');
	alreadySetup.droppable('disable');
	
	return this;
}

jQuery.fn.setupReparentDroppable = function() {
	this.droppable({
		accept: 'li.item',
		hoverClass: 'active',
		scope: 'item-reparent',
		tolerance: 'pointer',
		over: function(event, ui) { makeHyper($(this)); },
		out: function(event, ui) { removeHyper($(this)); },
		drop: drop,
	});
	return this;
	
	
	function makeHyper(dropBody) {
		dropBody.prepend('<div class="hyper"></div>');
	}
	
	function removeHyper(dropBody) {
		dropBody.children('.hyper').remove();
	}
	
	function drop(event, ui) {
		removeHyper($(this));
		
		itemReparent(ui.draggable, this);
	}
}

function itemReparent(node, parentNode) {
	if (!ClutterApp.fsm.changeAction('itemReparent', 'load')) {
		handleError(); // return the item back for now, since we have no way to prevent the drag from starting
		return;
	}
	
	node.required();
	parentNode = $(parentNode).closest('.item').required();
	
	collapseActionBar(); // so it doesn't get deleted when item it's contained on gets deleted
	node.children('.body').addClass('active');
	node.setCSS('opacity', 0.5); // doesn't seem to be working (perhaps being overridden via jQueryUI code?)
	
	nodeOutStart();
	parentNode.children('.body').required().showProgressOverlay();
	
	$.ajax({
		type: 'post',
		url: node.getAttr('oc\:url') + '/reparent',
		data: {_method: 'put', parent_id: nodeIDOfItem(parentNode)},
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	return;
	
	
	var nodeOutAnimDone = false;
	var nodeAJAXDone = false;
	
	function removeNodeWhenDone() {
		if (nodeOutAnimDone && nodeAJAXDone) {
			node.draggable('destroy');
			node.remove();
		}
	}
	
	function nodeOutStart() {
		node.show();
		
		var origNodeHeight = node.height();
		var origNodeOpacity = node.getCSS('opacity');
		
		var endScaleX = 0.95;
		var endScaleY = 0.25;
		node.setCSS({
			overflow: 'visible',
			        'transform-origin': '',
			   '-moz-transform-origin': '',
			'-webkit-transform-origin': '', // essentially, '50% 50%'
		}).animate(
			{opacity: 0.0},
			{
				duration: kDefaultTransitionDuration,
				easing: 'easeInQuad',
				step: function(opacity) {
					var ratio = opacity / origNodeOpacity;
					
					$(this).setCSS({
						'height': origNodeHeight * ratio,
					});
					
					var scaleValX = (1.0 - endScaleX) * ratio + endScaleX;
					var scaleValY = (1.0 - endScaleY) * ratio + endScaleY;
					$(this).setCSS({
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')',
					});
					
				},
				complete: function() {
					nodeOutAnimDone = true;
					removeNodeWhenDone();
				},
			}
		);
	}
	
	
	function handleSuccess(responseData) {
		hideProgressOverlay();
		
		
		parentNode.children('.body').removeClass('active');
		
		var list = parentNode.children('ul.item-list').required();
		
		$('li.item', list).draggable('destroy');
		$('.show.body', list).droppable('destroy');
		
		listCrossStart();
		
		nodeAJAXDone = true;
		removeNodeWhenDone();
		
		
		var oldListHeight;
		var newListHeight;
		var listPlaceholder;
		
		var newList;
		
		function listCrossStart() {
			// get old height
			oldListHeight = list.height();
			
			// set up placeholder
			list.after('<div id="list-placeholder" style="height: '+oldListHeight+'px;"></div>');
			listPlaceholder = $('#list-placeholder');
			
			list.setCSS({
				position: 'absolute',
				width: '100%',
				bottom: 0,
			});
			
			
			list.clone().insertAfter(list).html(responseData);
			newList = list.next('ul.item-list').required();
			// seems the sortable gets destroyed anyway, but the classes aren't removed; destroy again to be safe
			newList.sortable('destroy').removeClass('ui-sortable ui-sortable-disabled ui-state-disabled');
			
			newListHeight = newList.height();
			newList.setCSS('opacity', 0.0);
			
			newList.applyReparentDroppability();
			
			newList.setCSS({
				opacity: 0.0
			}).animate(
				{opacity: 1.0},
				{
					duration: kDefaultTransitionDuration,
					easing: 'easeOutQuad',
					step: function(ratio) {
						list.setCSS('opacity', 1.0 - ratio); // fade old list out as the new list fades in
						listPlaceholder.setCSS('height', (newListHeight - oldListHeight) * ratio + oldListHeight);
					},
					complete: listCrossFinish,
				}
			);
		}
		
		function listCrossFinish() {
			listPlaceholder.remove();
			list.remove();
			// return to normal positioning and remove unnecessary styles
			newList.setCSS({
				position: '',
				width: '',
				opacity: '',
				bottom: '',
			});
			
			
			ClutterApp.fsm.finishAction('itemReparent', 'load');
		}
	}
	
	function handleError(xhrObj, errStr, expObj) {
		parentNode.removeClass('active');
		
		function nodeOutRevert() {
			$(this).removeAttr('style'); // clear out unnecessary styles
		}
		
		node.find('.body:first .cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		
		
		ClutterApp.fsm.finishAction('itemReparent', 'load');
	}
}



function badgeAdd(link, addType) {
	var node = $(link).closest('li.item').required();
	
	var state;
	if (node.children('.new')[0]) {
		state = 'new';
		
		if (!ClutterApp.fsm.changeState('itemNew', 'badgeAddLoad'))
			return;
	} else if (node.children('.edit')[0]) {
		state = 'edit';
		
		if (!ClutterApp.fsm.changeState('itemEdit', 'badgeAddLoad'))
			return;
	} else {
		if (window.console && window.console.assert)
			window.console.assert('invalid state');
		
		return;
	}
	
	var form = node.find('form').required();
	var parentNode = node.parent().closest('.item').required();
	
	$.ajax({
		type: 'get',
		url: (state == 'new') ? form.getAttr('action').replace(/\?/, '/new?') : (node.getAttr('oc\:url') + '/edit'),
		data: form.serialize() + '&' + $.param({'add[prop_type]': addType}),
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		if (state == 'new')
		{
			var list = node.parent('.item-list').required();
			
			//var newBody = node.replaceWith(responseData); // possible?
			node.replaceWith(responseData);
			
			var newBody = list.children('li.new.item').find('.new.body').required();
			
			newBody.find('.note.prop').find('textarea').elastic();
			
			ClutterApp.fill.show(newBody);
			
			formFocus(newBody.find('form').required());
			
			
			ClutterApp.fsm.finishState('itemNew', 'badgeAddLoad');
		}
		else if (state == 'edit')
		{
			var showBody = node.children('.show.body').required();
			var editBody = showBody.siblings('.edit.body').required();
			
			//var editBody = node.replaceWith(responseData); // possible?
			editBody.replaceWith(responseData);
			
			var editBody = showBody.siblings('.edit.body').required();
			
			editBody.find('.note.prop').find('textarea').elastic();
			
			ClutterApp.fill.show(editBody);
			formFocus(editBody.find('form').required());
			
			
			ClutterApp.fsm.finishState('itemEdit', 'badgeAddLoad');
		}
	}
	
	function handleError(xhrObj, errStr, expObj) {
		node.find('.body:first .cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		
		
		ClutterApp.fsm.finishState('itemNew', 'badgeAddLoad') || ClutterApp.fsm.finishState('itemEdit', 'badgeAddLoad');
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
	
	var node = $(link).closest('li.item').required();
	
	var state;
	if (node.children('.new')[0]) {
		state = 'new';
		
		if (!ClutterApp.fsm.changeState('itemNew', 'badgeRemoveLoad'))
			return;
	} else if (node.children('.edit')[0]) {
		state = 'edit';
		
		if (!ClutterApp.fsm.changeState('itemEdit', 'badgeRemoveLoad'))
			return;
	} else {
		if (window.console && window.console.assert)
			window.console.assert('invalid state');
		
		return;
	}
	
	var form = node.find('form').required();
	var parentNode = node.parent().closest('li.item').required();
	
	$.ajax({
		type: 'get',
		url: (state == 'new') ? form.getAttr('action').replace(/\?/, '/new?') : (node.getAttr('oc\:url') + '/edit'),
		data: form.serialize(),
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		if (state == 'new')
		{
			var list = node.parent('.item-list').required();
			
			//var newBody = node.replaceWith(responseData); // possible?
			node.replaceWith(responseData);
			
			var newBody = list.children('li.new.item').find('.new.body').required();
			
			newBody.find('.note.prop').find('textarea').elastic();
			
			ClutterApp.fill.show(newBody);
			
			formFocus(newBody.find('form').required());
			
			
			ClutterApp.fsm.finishState('itemNew', 'badgeRemoveLoad');
		}
		else if (state == 'edit')
		{
			var showBody = node.children('.show.body').required();
			var editBody = showBody.siblings('.edit.body').required();
			
			//var editBody = node.replaceWith(responseData); // possible?
			editBody.replaceWith(responseData);
			
			var editBody = showBody.siblings('.edit.body').required();
			
			editBody.find('.note.prop').find('textarea').elastic();
			
			ClutterApp.fill.show(editBody);
			formFocus(editBody.find('form').required());
			
			
			ClutterApp.fsm.finishState('itemEdit', 'badgeRemoveLoad');
		}
	}
	
	function handleError(xhrObj, errStr, expObj) {
		node.find('.body:first .cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		
		
		ClutterApp.fsm.finishState('itemNew', 'badgeRemoveLoad') || ClutterApp.fsm.finishState('itemEdit', 'badgeRemoveLoad');
	}
}

$(function() {
	$('.line a.remove').live('click', function() { badgeRemove(this); return false; });
});



$(function() {
	ClutterApp.defaultPanelWidth = $('#scope-panel').width();
	
	var itemAreaCont = $('#item-area > .cont');
	var itemAreaMinWidth = parseInt( itemAreaCont.getCSS('min-width').match('[0-9]+')[0] );
	var itemAreaPadding = parseInt( itemAreaCont.getCSS('padding-left').match('[0-9]+')[0] ) + parseInt( itemAreaCont.getCSS('padding-right').match('[0-9]+')[0] );
	ClutterApp.itemAreaMinWidth = itemAreaMinWidth + itemAreaPadding + 16; // 16 extra for scrollbar
	
	
	var scopePanelCont = $('#scope-panel > .cont');
	var panelMinWidth = parseInt( scopePanelCont.getCSS('min-width').match('[0-9]+')[0] );
	var panelPadding = parseInt( scopePanelCont.getCSS('padding-left').match('[0-9]+')[0] ) + parseInt( scopePanelCont.getCSS('padding-right').match('[0-9]+')[0] );
	ClutterApp.panelMinWidth = panelMinWidth + panelPadding + 16; // 16 extra for scrollbar
});
ClutterApp.panelToggleMode = function() {
	return ClutterApp.itemAreaMinWidth + ClutterApp.panelMinWidth > window.innerWidth;
}


jQuery.fn.panelResize = function(panelWidth) {
	var panel = $(this).filter('.panel').required();
	var center = $('#item-area').required();
	
	var leftPanel = this.hasClass('left');
	var rightPanel = this.hasClass('right');
	
	// set manually here to keep them from lagging relative to each other
	panel.setCSS('width', panelWidth + 'px'); // setWidth() doesn't seem to work here initially, nor does setCSS('width', …) w/o the "+ 'px'"
	
	if (leftPanel)
		center.setCSS('margin-left', panelWidth + 'px');
	if (rightPanel)
		center.setCSS('margin-right', panelWidth + 'px');
}


jQuery.fn.panelFitToResizable = function() {
	var min = this.panelMinWidth();
	var max = this.panelMaxWidth();
	
	if (this.width() > max)
		this.panelResize(max);
	else if (this.width() < min)
		this.panelResize(min);
}


// saves the panel size as a cookie (and possibly sends it to the server in the future)
jQuery.fn.savePanelSize = function() {
	var panel = $(this).filter('.panel').required();
	
	$.cookie(
		panel.setAttr('id') + '.width',
		panel.width(),
		{ expires: 365, path: '/' }
	);
}

jQuery.fn.loadPanelSize = function() {
	var panel = $(this).filter('.panel').required();
	
	var savedPanelWidth = $.cookie(panel.setAttr('id') + '.width');
	
	if (savedPanelWidth)
		panel.panelResize(savedPanelWidth);
	else
		panel.panelResize( panel.defaultPanelSize() );
}

jQuery.fn.defaultPanelSize = function() {
	var panel = $(this).filter('.panel').required();
	
	if (ClutterApp.panelToggleMode())
		return 10;
	else
		return ClutterApp.defaultPanelWidth;
}

jQuery.fn.panelMinWidth = function() {
	var panel = $(this).filter('.panel').required();
	
	if (ClutterApp.panelToggleMode())
		return 10;
	else
		return ClutterApp.panelMinWidth;
}

jQuery.fn.panelMaxWidth = function() {
	var panel = $(this).filter('.panel').required();
	
	if (ClutterApp.panelToggleMode())
		return window.innerWidth - 10;
	else
		return window.innerWidth - ClutterApp.itemAreaMinWidth;
}


jQuery.fn.setupPanelResizable = function() {
	var leftPanel = this.hasClass('left');
	var rightPanel = this.hasClass('right');
	
	var panel = $(this); // for later use
	var handle = this.children('.back');
	
	this.resizable({
		handles: leftPanel ? {'e': '.ui-resizable-e'} : {'w': '.ui-resizable-w'},
		resize: function(event, ui) {
			panel.panelResize(ui.size.width);
		},
		stop: function(event, ui) {
			panel.panelResize(ui.size.width);
			panel.savePanelSize();
		},
		minWidth: this.panelMinWidth(),
		maxWidth: this.panelMaxWidth(),
		delay: 20,
		distance: 10,
		ghost: true,
	});
	
	return this;
}


jQuery.fn.refreshPanelResizable = function() {
	this.resizable('option', 'minWidth', this.panelMinWidth());
	this.resizable('option', 'maxWidth', this.panelMaxWidth());
	
	return this;
}


jQuery.fn.setupPanelToggle = function(eventType) {
	if (eventType == undefined)
		eventType = 'click';
	
	var panel = $(this).filter('.panel').required();
	
	panel.children('a.toggle').bind(eventType, function() {
		if (panel.width() <= panel.defaultPanelSize()) {
			panel.animate(
				{ width: panel.panelMaxWidth() },
				{
					duration: kSlowTransitionDuration * 2,
					easing: 'easeInOutExpo',
					step: function(width) { panel.panelResize(width); },
					complete: function() { panel.savePanelSize(); },
				}
			);
		} else {
			panel.animate(
				{ width: panel.panelMinWidth() },
				{
					duration: kSlowTransitionDuration * 2,
					easing: 'easeInOutExpo',
					step: function(width) { panel.panelResize(width); },
					complete: function() { panel.savePanelSize(); },
				}
			);
		}
		return false;
	});
}


$(function() {
	var panel = $('#scope-panel');
	
	panel.loadPanelSize();
	panel.panelFitToResizable();
	// no real need to save; if we resized to fit, we can do it again
	
	if (ClutterApp.hasMouseSupport)
		panel.setupPanelResizable();
	
	panel.setupPanelToggle(ClutterApp.hasMouseSupport ? 'dblclick' : 'click');
});

var resizeTimer = null;
window.onresize = function() {
	var panel = $('#scope-panel');
	
	panel.refreshPanelResizable();
	panel.panelFitToResizable();
	
	
	// to prevent constantly rapid-fire saving
	if (resizeTimer) clearTimeout(resizeTimer);
		resizeTimer = setTimeout("$('#scope-panel').savePanelSize();", 500);
}


$(function() {
	ClutterApp.touchInfo = {
		kMinMoveToScroll: 5,
		kDecelFrictionFactor: 0.95,
		first: null,
		prev: null,
		isScrolling: false,
		origTarget: null,
	};
	
	var panel = $('#scope-panel').required();
	var center = $('#item-area').required();
	
	
	panel[0].ontouchstart = function(e) { touchStarted(e, panel); };
	center[0].ontouchstart = function(e) { touchStarted(e, center); };
	panel[0].ontouchmove = function(e) { touchMoved(e, panel); };
	center[0].ontouchmove = function(e) { touchMoved(e, center); };
	panel[0].ontouchend = function(e) { touchEnded(e, panel); };
	center[0].ontouchend = function(e) { touchEnded(e, center); };
	
	function touchStarted(e, areaElement) {
		var touch = e.changedTouches[0];
		ClutterApp.touchInfo.first = {
			y: touch.screenY,
			id: touch.identifier,
		};
		ClutterApp.touchInfo.prev = ClutterApp.touchInfo.first;
		
		ClutterApp.touchInfo.origTarget = touch.target;
		
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
		
		var deltaY = ClutterApp.touchInfo.prev.y - currTouchInfo.y;
		areaElement.scrollTop(areaElement.scrollTop() + deltaY);
		
		ClutterApp.touchInfo.prev = currTouchInfo;
		
		e.preventDefault();
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
			ClutterApp.touchInfo.isScrolling = false;
		}
		
		ClutterApp.touchInfo.first = null;
		ClutterApp.touchInfo.prev = null;
		
		e.preventDefault();
		e.stopPropagation();
	}
});
