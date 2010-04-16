// ClutterApp touch-compatibilty JS

document.observe('dom:loaded', function() {
	Prototype.BrowserFeatures.Touch = (typeof Touch == 'object');
	if (Prototype.BrowserFeatures.Touch) {
		$('main-area').setStyle({position: 'static'});
		$('page').setStyle({position: 'relative', top: 'auto', bottom: 'auto'});
	}
});
