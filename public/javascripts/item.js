// ClutterApp item view functionality JS


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
	showFill();
	
	var parentNode = $(button).closest('.item_for_node');
	
	$.ajax({
		type: 'get',
		url: parentNode.closest('.pile').getAttr('oc\:nodes-url') + '/new',
		data: {'node[prop_type]': type, 'node[parent_id]': nodeIDOfItem(parentNode)},
		dataType: 'html',
		success: function(responseData) { handleSuccess(parentNode, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(parentNode, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(parentNode, responseData) {
		collapseActionBar();
		
		var list = parentNode.children('.list').required();
		
		list.append(responseData);
		
		var newBody = list.children('.item_for_node:last').find('.new.body').required();
		newBody.hide().fadeIn(kDefaultTransitionDuration);
		
		newBody.find('.note.prop').find('textarea').elastic();
		
		showFill(newBody);
		
		var newBodyForm = newBody.find('form').required();
		formFocus(newBodyForm.required());
	}
	
	function handleError(parentNode, xhrObj, errStr, expObj) {
		hideFill();
		
		parentNode.children('.show.body')
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000); // @todo: fix
	}
}
	
$(function() {
	var actionButtons = $('#action-bar > .buttons > a.new').required()
		.click(function() { itemNew(this, 'text'); return false; });
});



function itemCreate(form) {
	form.required();
	
	$.ajax({
		type: form.getAttr('method'), // 'post'
		url: form.getAttr('action'),
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
		form.closest('.new.body').find('.cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		
		formFocus(form);
	}
}

$(function() {
	$('form.new_node').live('submit', function() {
		itemCreate($(this)); return false;
	});
});



function itemEdit(link) {
	showFill();
	
	var showBody = $(link).closest('.show.body').required();
	
	$.ajax({
		type: 'get',
		url: showBody.closest('.node').getAttr('oc\:url') + '/edit',
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


function itemUpdate(form) {
	$.ajax({
		type: form.getAttr('method'), // 'post' (PUT)
		url: form.getAttr('action'),
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
		form.closest('.edit.body').find('.cont').required()
			.effect('highlight', {color: 'rgb(31, 31, 31)'}, 2000);
		
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
		url: node.getAttr('oc\:url') + '/move',
		data: {_method: 'put', dir: dir},
		dataType: 'script',
		success: function(responseData) { handleSuccess(node, responseData); },
		error: function(xhrObj, errStr, expObj) { handleError(node, xhrObj, errStr, expObj); }
	});
	
	
	function handleSuccess(node, responseData) {
		// nothing for now; @todo: do the actual element movement here
	}
	
	function handleError(node, xhrObj, errStr, expObj) {
		node.find('.body:first .cont').required()
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
		url: node.getAttr('oc\:url'),
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
	else if (typeof(console) != 'undefined' && typeof(console.assert) != 'undefined')
		console.assert('invalid state');
	
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
