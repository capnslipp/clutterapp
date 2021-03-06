// ClutterApp JS utils


jQuery.fn.exists = function() {
	return !!this[0];
}

jQuery.fn.walk = function() {
	var firstChild = this.children(':first');
	if (firstChild.exists()) {
		return firstChild;
	} else {
		var nextSibling = this.next()
		if (nextSibling.exists())
			return nextSibling;
		else
			return this.closest(':not(:last-child)').next();
	}
}

jQuery.fn.required = function() {
	if (window.console && window.console.assert)
		window.console.assert(this.exists());
	
	return this;
}

jQuery.fn.require = function(selector) {
	return this.filter(selector).required();
}

$.extend(String.prototype, {
	// function derived from jQuery.backgroundPosition
	asBGPosToArray: function() {
		var strg = this; // make of copy of ourself (a string), so we don't change the contents
		strg = strg.replace(/left|top/g, '0px');
		strg = strg.replace(/right|bottom/g, '100%');
		strg = strg.replace(/([0-9\.]+)(\s|\)|$)/g, "$1px$2");
		var res = strg.match(/(-?[0-9\.]+)(px|\%|em|pt)\s(-?[0-9\.]+)(px|\%|em|pt)/);
		return [
			parseFloat(res[1], 10),
			res[2],
			parseFloat(res[3], 10),
			res[4]
		];
	}
});
