CA._activeItem = null;
CA.getActiveItem = function() { return _activeItem; };
CA.setActiveItem = function(item) {
	if (item == this._activeItem)
		return;
	
	if (this._activeItem) {
		this.inactiveItemBodyMorph( this._activeItem.select('> .cont > .body').first() );
		
		var textPropInput = this._activeItem.select('> .cont > .body > .cont > input.text.prop').first();
		if (textPropInput) {
			CA.activeItemInputChanged();
			
			textPropInput.remove();
			var textProp = this._activeItem.select('> .cont > .body > .cont > div.text.prop').first();
			textProp.setStyle({visibility: 'visible'});
		}
	}
	
	this._activeItem = $(item);
	
	if (this._activeItem) {
		this.activeItemBodyMorph( this._activeItem.select('> .cont > .body').first() );
		
		var textProp = this._activeItem.select('> .cont > .body > .cont > div.text.prop').first();
		if (textProp) {
			var textContent = textProp.innerHTML.unescapeHTML().strip();
			var textClass = textProp.readAttribute('class');
			textProp.insert({
				before: new Element('input', {
					className: 'magic ' + textClass,
					value: textContent
				}),
			});
			var textPropInput = this._activeItem.select('> .cont > .body > .cont > input.text.prop').first();
			var textPropDimens = textProp.getDimensions();
			textPropInput.setStyle({
				position: 'absolute',
				width: textPropDimens.width + 'px',
				height: textPropDimens.height + 'px',
			});
			textProp.setStyle({visibility: 'hidden'});
			textPropInput.observe('keypress', function(e) {
				CA.activeItemInputChanged();
				//setTimeout('CA.activeItemInputChanged()', 500);
			});
		}
	}
};
CA.activeItemInputChanged = function() {
	var prop = this._activeItem.select('> .cont > .body > .cont > div.text.prop').first();
	var input = this._activeItem.select('> .cont > .body > .cont > input.text.prop').first();
	
	var textContent = input.getValue().escapeHTML();
	prop.innerHTML = textContent;
	
	var propDimens = prop.getDimensions();
	input.setStyle({
		width: (propDimens.width + 26) + 'px',
		height: propDimens.height + 'px',
	});
}
CA.activeItemBodyMorph = function(body) {
	var back = body.select('> .back').first();
	
	body.addClassName('active');
	back.setStyle({opacity: 1}); // in case it was hidden by inactiveItemBodyMorph
}
CA.inactiveItemBodyMorph = function(body) {
	var back = body.select('> .back').first();
	
	back.morph({opacity: 0}, {
		duration: 0.4,
		transition: 'easeOutQuad',
		after: function() {
			body.removeClassName('active');
		},
	});
}

document.observe('dom:loaded', function() {
	$$('.item > .cont > .body').each(function(itemBody) {
		itemBody.observe('click', function(event) {
			CA.setActiveItem(itemBody.parentNode.parentNode);
		})
	});
});
