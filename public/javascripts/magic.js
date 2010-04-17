/// call CA.Item() with the same args you'd given to $() in order to get an item element
/// CA.Item() will spit back a CA.Item object if you passed in an item; othersie, nothing
CA.Item = function(ref) {
	var ref = $(ref);
	
	if (ref) {
		// if a CA.Item object already exists for this element, return it
		if (ref.caItem) {
			return ref.caItem;
		}
		// otherwise, create and hook up a new CA.Item object
		else if (ref.hasClassName('item')) {
			var item = new CA.Item;
			
			initElement();
			initBody();
			initBack();
			
			return item;
		}
	}
	
	return undefined;
	
	function initElement() {
		// member private to the scope of the CA.Item instance
		var _element = ref;
		
		item.element = function() { return _element; }
		
		_element.caItem = item;
	};
	
	function initBody() {
		// member private to the scope of the CA.Item instance
		var _body = null;
		
		item.body = function() {
			if (!_body)
				_body = this.element().select('> .cont > .body').first();
			
			return _body;
		}
	};
	
	function initBack() {
		// member private to the scope of the CA.Item instance
		var _back = null;
		
		item.back = function() {
			if (!_back)
				_back = this.body().select('> .back').first();
			
			return _back;
		}
	};
};

var n = function() {
	// member private to the scope of the CA.Item
	var _activeItem = null;
	
	CA.Item.active = function() {
		return _activeItem;
	};
	
	CA.Item.prototype.activate = function() {
		if (this.isActive())
			return;
		
		if (_activeItem)
			_activeItem.deactivate();
		
		_activeItem = this;
		
		this.visualActivate();
	};
	
	CA.Item.prototype.deactivate = function() {
		if (!this.isActive())
			return;
		
		this.visualDeactivate();
		
		_activeItem = null;
	};
	
	CA.Item.prototype.isActive = function() {
		return this == _activeItem;
	}
}();

CA.Item.prototype.visualActivate = function() {
	this.bodyMorphActive();
	
	var textProp = this.body().select('> .cont > div.text.prop').first();
	if (textProp) {
		var textContent = textProp.innerHTML.unescapeHTML().strip();
		var textClass = textProp.readAttribute('class');
		textProp.insert({
			before: new Element('input', {
				className: 'magic ' + textClass,
				value: textContent
			}),
		});
		var textPropInput = this.body().select('> .cont > input.text.prop').first();
		var textPropDimens = textProp.getDimensions();
		textPropInput.setStyle({
			position: 'absolute',
			width: textPropDimens.width + 'px',
			height: textPropDimens.height + 'px',
		});
		textProp.setStyle({visibility: 'hidden'});
		
		textPropInput.observe('keypress', function(e) {
			this.inputChanged();
		});
	}
}

CA.Item.prototype.visualDeactivate = function() {
	this.bodyMorphInactive();
	
	var textPropInput = this.body().select('> .cont > input.text.prop').first();
	if (textPropInput) {
		this.inputChanged();
		
		textPropInput.remove();
		var textProp = this.body().select('> .cont > div.text.prop').first();
		textProp.setStyle({visibility: 'visible'});
	}
}


CA.Item.prototype.inputChanged = function() {
	var prop = this.body().select('> .cont > div.text.prop').first();
	var input = this.body().select('> .cont > input.text.prop').first();
	
	var textContent = input.getValue().escapeHTML();
	prop.innerHTML = textContent;
	
	var propDimens = prop.getDimensions();
	input.setStyle({
		width: (propDimens.width + 26) + 'px',
		height: propDimens.height + 'px',
	});
}
CA.Item.prototype.bodyMorphActive = function(body) {
	this.body().addClassName('active');
	this.back().setStyle({opacity: 1}); // in case it was hidden by bodyMorphInactive
}
CA.Item.prototype.bodyMorphInactive = function() {
	var body = this.body();
	
	this.back().morph({opacity: 0}, {
		duration: 0.4,
		transition: 'easeOutQuad',
		after: function() {
			body.removeClassName('active');
		},
	});
}

document.observe('dom:loaded', function() {
	$$('.item').each(function(item) {
		item.select('> .cont > .body').first().observe('click', function(event) {
			CA.Item(item).activate();
		});
	});
});
