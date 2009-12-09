// ClutterApp item view functionality JS


var JOIN = '_';
var NEW = 'new';

var kSlowTransitionDuration = 375;
var kDefaultTransitionDuration = 250;
var kQuickTransitionDuration = 125;


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


function nodeIDOfItem(itemForNode) {
	return itemForNode.getAttr('id').substring('item_for_node_'.length);
}



function expandActionBar(node) {
	collapseActionBar();
	
	var nodeBody = node.children('.body').required();
	
	nodeBody.children('.action.stub').hide();
	
	nodeBody.addClass('active');
	
	if (!nodeBody.find('#action-bar')[0])
		$('#action-bar').prependTo(nodeBody);
	
	// since it may be initially-hidden
	safeShow($('#action-bar'));
}

function collapseActionBar() {
	$('#action-bar').hide()
	
	var node = $('#action-bar').closest('.item_for_node').required();;
	var nodeBody = node.children('.body').required();
	
	nodeBody.children('.action.stub').show();
	
	nodeBody.removeClass('active');
		
	$('#action-bar').appendTo($('.pile:first')); // in case the parent item gets deleted
}

$(function() {
	$('.item_for_node > .show.body > .cont').live('click', function() {
		expandActionBar($(this).closest('.item_for_node')); return false;
	});
	$('.pile.item_for_node > .body > .header').live('click', function() {
		expandActionBar($(this).closest('.item_for_node')); return false;
	});
});

$(function() {
	$('.action.stub .widget.collapsed a').live('click', function() {
		expandActionBar($(this).closest('.item_for_node')); return false;
	});
	
	$('#action-bar .widget.expanded a')
		.click(function() { collapseActionBar(); return false; });
});



function formFocus(form) {
	form.find('.field:first').required()
		.focus();
}



function itemNew(button, type) {
	var parentNode = $(button).closest('.item_for_node').required();
	
	collapseActionBar();
	parentNode.showProgressOverlay();
	showFill();
	
	$.ajax({
		type: 'get',
		url: parentNode.closest('.pile').getAttr('oc\:nodes-url') + '/new',
		data: {'node[prop_type]': type, 'node[parent_id]': nodeIDOfItem(parentNode)},
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		hideProgressOverlay();
		
		var list = parentNode.children('.list').required();
		
		list.append(responseData);
		
		var newBody = list.children('.item_for_node:last').find('.new.body').required();
		
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
					newBody.setCSS({
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
					})
				}
			}
		);
		
		newBody.find('.note.prop').find('textarea').elastic();
		
		showFill(newBody);
		
		var newBodyForm = newBody.find('form').required();
		formFocus(newBodyForm.required());
	}
	
	function handleError(xhrObj, errStr, expObj) {
		hideProgressOverlay();
		hideFill();
		
		parentNode.children('.show.body')
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000); // @todo: fix
	}
}
	
$(function() {
	var actionButtons = $('#action-bar > .buttons > a.new').required()
		.click(function() { itemNew(this, 'text'); return false; });
});



function itemNewCancel(button) {
	var form = button.closest('form.new_node').required();
	
	form.find('input[type=submit], input[type=button]').required().setAttr('disabled', 'disabled');
	
	var newBody = form.closest('.new.body').required();
	
	hideFill();
		
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
				newBody.setCSS({
					        'transform': 'scale('+scaleValX+', '+scaleValY+')',
					   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
					'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
				})
			},
			complete: function() {
				newBody.closest('.item_for_node').required().remove();
			}
		}
	);
}

$(function() {
	$('form.new_node input.cancel').live('click', function() {
		itemNewCancel($(this)); return false;
	});
});



function itemCreate(form) {
	form.required();
	
	form.find('input[type=submit], input[type=button]').required().setAttr('disabled', 'disabled');
	
	var newBody = form.closest('.new.body').required();
	var newItem = newBody.closest('.item_for_node').required();
	
	newBody.showProgressOverlay({opacity: 0.25});
	
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
					newBody.setCSS({
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
					})
				},
				complete: function() {
					newItem.remove();
				}
			}
		);
		
		hideFill();
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
	}
}

$(function() {
	$('form.new_node').live('submit', function() {
		itemCreate($(this)); return false;
	});
});



function itemEdit(link) {
	var showBody = $(link).closest('.show.body').required();
	
	collapseActionBar();
	showBody.showProgressOverlay();
	showFill();
	
	$.ajax({
		type: 'get',
		url: showBody.closest('.node').getAttr('oc\:url') + '/edit',
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		hideProgressOverlay();
		
		showBody.before(responseData);
		
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
					editBody.setCSS({
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
					})
				}
			}
		);
		
		editBody.find('.note.prop').find('textarea').elastic();
		
		showFill(editBody);
		formFocus(editBody.find('form').required());
	}
	
	function handleError(xhrObj, errStr, expObj) {
		hideProgressOverlay();
		hideFill();
		
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



function itemEditCancel(button) {
	var form = button.closest('form.edit_node').required();
	
	form.find('input[type=submit], input[type=button]').required().setAttr('disabled', 'disabled');
	
	var editBody = form.closest('.edit.body').required();
	
	hideFill();
	
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
				editBody.setCSS({
					        'transform': 'scale('+scaleVal+')',
					   '-moz-transform': 'scale('+scaleVal+')',
					'-webkit-transform': 'scale('+scaleVal+')'
				})
			},
			complete: function() {
				editBody.remove();
			}
		}
	);
}

$(function() {
	$('form.edit_node input.cancel').live('click', function() {
		itemEditCancel($(this)); return false;
	});
});



function itemUpdate(form) {
	form.required();
	
	form.find('input[type=submit], input[type=button]').required().setAttr('disabled', 'disabled');
	
	var editBody = form.closest('.edit.body').required();
	var showBody = editBody.siblings('.show.body').required();
	
	editBody.showProgressOverlay({opacity: 0.25});
	
	$.ajax({
		type: form.getAttr('method'), // 'post' (PUT)
		url: form.getAttr('action'),
		data: form.serialize(),
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
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
					editBody.setCSS({
						        'transform': 'scale('+scaleValX+', '+scaleValY+')',
						   '-moz-transform': 'scale('+scaleValX+', '+scaleValY+')',
						'-webkit-transform': 'scale('+scaleValX+', '+scaleValY+')'
					})
				},
				complete: function() {
					editBody.remove();
				}
			}
		);
		
		hideFill();
		
		showBody.replaceWith(responseData);
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
	}
}

$(function() {
	$('form.edit_node').live('submit', function() {
		itemUpdate($(this)); return false;
	});
});



function itemDelete(node) {
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
		node.remove();
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
			itemDelete($(this).closest('.item_for_node'));
		
		return false;
	});
});



$(function() {
	$().applyReorderability();
});

jQuery.fn.applyReorderability = function() {
	this.find('ul.node.list').setupReorderSortable();
	return this;
}

jQuery.fn.setupReorderSortable = function() {
	var elementHeight;
	var origPrevSiblingID;
	
	this.sortable({
		axis: 'y',
		containment: '#active-sorting-container',
		tolerance: 'intersect',
		handle: '> .show.body > #action-bar .move.reorder',
		helper: helper,
		opacity: 0.5,
		revert: true,
		scroll: true,
		start: start,
		stop: stop
	});
	return this;
	
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
		var list = element.parent('ul.node.list').required();
		
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
		var list = ui.item.parent('ul.node.list').required();
		showFill(list);
		list.addClass('active');
		
		var origPrevSibling = ui.item.prev('.item_for_node');
		origPrevSiblingID = origPrevSibling[0] ? nodeIDOfItem(origPrevSibling) : '';
	}
	
	function stop(event, ui) {
		var list = ui.item.parent('ul.node.list').required();
		
		$('#active-sorting-container').required().replaceWith(
			$('#active-sorting-container > ul.node.list').required()
		);
		list.setCSS({margin: ''});
		
		// @todo: optimize so this isn't being done twice
		var prevSibling = ui.item.prev('.item_for_node');
		var prevSiblingID = prevSibling[0] ? nodeIDOfItem(prevSibling) : '';
		
		// only if the prevSibling has changed
		if (prevSiblingID != origPrevSiblingID) {
			itemReorder(ui.item);
		} else {
			hideFill(list);
			list.removeClass('active');
		}
	}
}

function itemReorder(node) {
	node.required();
	
	var list = node.parent('ul.node.list').required();
	
	var prevSibling = node.prev('.item_for_node');
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
		hideFill(list);
		list.removeClass('active');
	}
	
	function handleError(xhrObj, errStr, expObj) {
		node.find('.body:first .cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}



$(function() {
	$().applyReparentability();
});

jQuery.fn.applyReparentability = function() {
	this.find('li.item_for_node').setupReparentDraggable();
	this.find('.item_for_node>.show.body, .pile.item_for_node>.body').setupReparentDroppable();
	return this;
}

jQuery.fn.setupReparentDraggable = function() {
	this.draggable({
		axis: 'y',
		cancel: '.body > .cont, .body > .bullet, .body > .action.stub, .edit.body, .new.body',
		handle: '> .body > #action-bar a.move.reparent',
		opacity: 0.5,
		revert: 'invalid',
		scope: 'item-reparent',
		scroll: true,
		zIndex: 1000,
	});
	return this;
}

jQuery.fn.setupReparentDroppable = function() {
	this.droppable({
		accept: 'li.item_for_node',
		hoverClass: 'active',
		scope: 'item-reparent',
		tolerance: 'intersect',
		drop: drop,
	});
	return this;
	
	function drop(event, ui) {
		itemReparent(ui.draggable, this);
	}
}

function itemReparent(node, parentNode) {
	node.required();
	parentNode = $(parentNode).closest('.item_for_node').required();
	
	collapseActionBar(); // so it doesn't get deleted
	node.draggable('destroy');
	node.remove();
	
	$.ajax({
		type: 'post',
		url: node.getAttr('oc\:url') + '/reparent',
		data: {_method: 'put', parent_id: nodeIDOfItem(parentNode)},
		dataType: 'html',
		success: handleSuccess,
		error: handleError
	});
	
	
	function handleSuccess(responseData) {
		parentNode.children('.body').removeClass('active');
		
		var list = parentNode.children('.node.list').required();
		
		$('li.item_for_node', list).draggable('destroy');
		$('.show.body', list).droppable('destroy');
		
		var listParent = list.parent();
		list.html(responseData);
		
		listParent.applyReparentability();
		listParent.applyReorderability();
	}
	
	function handleError(xhrObj, errStr, expObj) {
		parentNode.removeClass('active');
		
		node.find('.body:first .cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}



function badgeAdd(link, addType) {
	var node = $(link).closest('.item_for_node').required();
	
	var state;
	if (node.children('.new')[0])
		state = 'new';
	else if (node.children('.edit')[0])
		state = 'edit';
	else if (window.console && window.console.assert)
		window.console.assert('invalid state');
	
	var form = node.find('form').required();
	var parentNode = node.parent().closest('.item_for_node').required();
	
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
		node.find('.body:first .cont').required()
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
	else if (window.console && window.console.assert)
		window.console.assert('invalid state');
	
	var form = node.find('form').required();
	var parentNode = node.parent().closest('.item_for_node').required();
	
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
		node.find('.body:first .cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
	}
}

$(function() {
	$('.line a.remove').live('click', function() { badgeRemove(this); return false; });
});
