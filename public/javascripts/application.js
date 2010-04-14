// ClutterApp main application JS

CA = {};


CA._activeItem = null;
CA.getActiveItem = function() { return _activeItem; };
CA.setActiveItem = function(item) {
	if (item == this._activeItem)
		return;
	
	if (this._activeItem) {
		this.inactiveItemBodyMorph( this._activeItem.select('> .cont > .body').first() );
		
		var textPropInput = this._activeItem.select('> .cont > .body > .cont > input.text.prop').first();
		if (textPropInput) {
			var textValue = textPropInput.getValue();
			var textClass = textPropInput.readAttribute('class');
			textPropInput.replace('<div class="'+textClass+'">'+textValue.escapeHTML()+'</div>');
		}
	}
	
	this._activeItem = $(item);
	
	if (this._activeItem) {
		this.activeItemBodyMorph( this._activeItem.select('> .cont > .body').first() );
		
		var textProp = this._activeItem.select('> .cont > .body > .cont > .text.prop').first();
		if (textProp) {
			var textContent = textProp.innerHTML.unescapeHTML();
			var textClass = textProp.readAttribute('class');
			textProp.replace('<input class="'+textClass+'" value="'+textContent+'"/>');
			var textPropInput = this._activeItem.select('input.text.prop').first();
			textPropInput.focus();
		}
	}
};
CA.activeItemBodyMorph = function(element) {
	var body = $(element);
	var back = body.select('> .back').first();
	
	body.addClassName('active');
	back.setStyle({opacity: 1}); // in case it was hidden by inactiveItemBodyMorph
}
CA.inactiveItemBodyMorph = function(element) {
	var body = $(element);
	var back = body.select('> .back').first();
	
	back.morph({opacity: 0}, {
		duration: 0.4,
		transition: 'easeOutQuad',
		after: function() {
			body.removeClassName('active');
		},
	});
}

document.observe('dom:loaded', function()
{
	$$('.item > .cont > .body').each(function(itemBody) {
		itemBody.observe('click', function(event) {
			CA.setActiveItem(itemBody.parentNode.parentNode);
		})
	});
});
