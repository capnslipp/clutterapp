// ClutterApp main application JS

CA = {};

$x = function(expression) {
	return document._getElementsByXPath(expression);
}

Element.addMethods({
	x: function(element, expression) {
		return document._getElementsByXPath(expression, element);
	}
});
