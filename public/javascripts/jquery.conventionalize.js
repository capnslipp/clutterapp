/**
*	@name:			jQuery.Conventionalize
*	@descripton:	A whole bunch of function aliases for jQuery to make it follow the traditional JavaScript naming conventions more closely and to make jQuery usable by mere mortals.
*	@version:		0.?
*	@requires:		jQuery v1.3.2
*	@author:		Slippy Douglas <'work' + AT + 'dyppils'.split('').reverse().join('') + '.com'>
*/
// 

jQuery.fn.getAttr = function(name) { return this.attr(name); }
jQuery.fn.setAttr = function(name, value, type) { return this.attr(name, value, type); }

jQuery.fn.getData = function(key) { return this.data(key); }
jQuery.fn.setData = function(key, value) { return this.data(key, value); }

jQuery.fn.getCSS = function(key) { return this.css(key); }
jQuery.fn.setCSS = function(key, value) { return this.css(key, value); }
