// ClutterApp JS utils


jQuery.fn.walk = function() {
	var firstChild = this.children(':first');
	if (firstChild[0]) {
		return firstChild;
	} else {
		var nextSibling = this.next()
		if (nextSibling[0])
			return nextSibling;
		else
			return this.closest(':not(:last-child)').next();
	}
}

jQuery.fn.required = function() {
	if (typeof(console) != 'undefined' && typeof(console.assert) != 'undefined')
		console.assert(this[0]);
	
	return this;
}