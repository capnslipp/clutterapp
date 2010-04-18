/// An Item is a single highlightable line in ClutterApp.
/// 	It may have multiple Props, just one, or zero (but cannot exist in a non-active state with zero Props).
/// 	Normally, only one Item can be active at a time; however, multi-select may break this rule.
/// Call CA.Item() with the same args you'd given to $() in order to get an item element.
/// 	CA.Item() will spit back a CA.Item object if you passed in an item; otherwise, nothing.
CA.Item = function(ref) {
	var ref = $(ref);
	
	if (ref) {
		// if a CA.Item object already exists for this element, return it
		if (ref._caItem) {
			return ref._caItem;
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
		// member private to the scope of the instance
		var _element = ref;
		
		item.element = function() { return _element; }
		
		_element._caItem = item;
	};
	
	function initBody() {
		// member private to the scope of the instance
		var _body = null;
		
		item.body = function() {
			if (!_body)
				_body = this.element().select('> .cont > .body')[0];
			
			return _body;
		}
	};
	
	function initBack() {
		// member private to the scope of the instance
		var _back = null;
		
		item.back = function() {
			if (!_back)
				_back = this.body().select('> .back')[0];
			
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

/// A Prop is a single attribute on an Item.
/// 	It has one chunk of data within it that can be tranformed into one editable form field.
/// 	Only one Prop may be active at a time (since it's tied to the browser form field focus) and must always correspond to the active Item.
/// Call CA.Prop() with the same args you'd given to $() in order to get a prop element.
/// 	CA.Prop() will spit back a CA.Prop object if you passed in an item; otherwise, nothing.
CA.Prop = function(ref) {
	var ref = $(ref);
	
	if (ref) {
		// if a CA.Prop object already exists for this element, return it
		if (ref._caProp) {
			return ref._caProp;
		}
		// otherwise, create and hook up a new CA.Item object
		else if (ref.hasClassName('prop')) {
			var prop = new CA.Prop;
			
			initElement();
			initItem();
			
			return prop;
		}
	}
	
	return undefined;
	
	function initElement() {
		// member private to the scope of the instance
		var _element = ref;
		
		prop.element = function() { return _element; }
		
		_element._caProp = prop;
	};
	
	function initItem() {
		// member private to the scope of the instance
		var _item = prop.element().up('.item');
		
		prop.item = function() { return _item; }
	};
};

var n = function() {
	CA.Item.prototype.props = function() {
		return this.body().select('> .cont > div.prop').collect(function(e) {
			return CA.Prop(e);
		});
	};
	
	CA.Item.prototype.textProps = function() {
		return this.body().select('> .cont > div.text.prop').collect(function(e) {
			return CA.Prop(e);
		});
	};
}();

CA.Prop.prototype.input = function() {
	var prevElement = this.element().previous();
	if (Prototype.Selector.match(prevElement, 'input'))
		return prevElement;
	else
		return null;
};

CA.Item.prototype.visualActivate = function() {
	this.bodyMorphActive();
	
	this.textProps().each(function(p) {
		var content = p.element().innerHTML;
		var classes = p.element().readAttribute('class');
		p.element().insert({
			before: new Element('input', {
				className: 'magic ' + classes,
				value: content.unescapeHTML().strip()
			}),
		});
		
		p.input().setStyle({position: 'absolute'});
		p.element().setStyle({visibility: 'hidden'});
		
		p.inputChanged();
		p.input().observe('keypress', p.inputChanged.bind(p));
	});
};

CA.Item.prototype.visualDeactivate = function() {
	this.bodyMorphInactive();
	
	this.textProps().each(function(p) {
		p.inputChanged();
		
		p.input().remove();
		
		p.element().setStyle({visibility: 'visible'});
	});
};

CA.Item.prototype.bodyMorphActive = function(body) {
	this.body().addClassName('active');
	this.back().setStyle({opacity: 1}); // in case it was hidden by bodyMorphInactive
};

CA.Item.prototype.bodyMorphInactive = function() {
	var body = this.body();
	this.back().morph({opacity: 0}, {
		duration: 0.4,
		transition: 'easeOutQuad',
		after: function() {
			body.removeClassName('active');
		},
	});
};

CA.Prop.prototype.inputChanged = function() {
	this.element().update(
		this.input().getValue().escapeHTML()
	);
	
	var dimens = this.element().getDimensions();
	this.input().setStyle({
		width: (dimens.width + 26) + 'px',
		height: dimens.height + 'px',
	});
};

document.observe('dom:loaded', function() {
	$$('.item').each(function(i) {
		CA.Item(i).body().observe('click', function(event) {
			CA.Item(i).activate();
		});
	});
});
