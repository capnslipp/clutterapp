/**
*	@name:			jQuery.Conventionalize
*	@descripton:	A whole bunch of function aliases for jQuery to make it follow the traditional JavaScript naming conventions more closely and to make jQuery usable by mere mortals.
*	@version:		0.?
*	@requires:		jQuery v1.3.2
*	@author:		Slippy Douglas <'work' + AT + 'dyppils'.split('').reverse().join('') + '.com'>
*/


// aliases for poorly named jQuery function

jQuery.fn.getAttr = function(name) { return this.attr(name); }
jQuery.fn.setAttr = function(name, value, type) { return this.attr(name, value, type); }

jQuery.fn.getData = function(key) { return this.data(key); }
jQuery.fn.setData = function(key, value) { return this.data(key, value); }

jQuery.fn.getCSS = function(key) { return this.css(key); }
jQuery.fn.setCSS = function(key, value) { return this.css(key, value); }

jQuery.fn.setWidth = function(val) { return this.width(val); }
jQuery.fn.setHeight = function(val) { return this.height(val); }

jQuery.fn.searchInside = jQuery.fn.find;


// additional functionality that should be built into jQuery

// inefficient, but effective
// @todo: optimize, otherwise burn Sizzle
jQuery.fn.search = function(selector) {
	if (!this.parent()[0]) // if we're at the root DOM node (document)
		return this.searchInside(selector); // just do a normal find
	
	var self = this; // save off the "this" that search() was called on
	var overScoped = this.parent().find(selector); // do an oveyly-large find for the parent's scope (inefficient)
	var searched = $([]); // to add all the qualifying elements into
	overScoped.each(function() {
		if ($(this).index(self) >= 0 || $(this).parents().index(self) >= 0) // if the element either is "self", or has "self" as an ancestor, it's good
			searched = searched.add(this); // save it in the array that will be returned
	});
	return searched;
}
