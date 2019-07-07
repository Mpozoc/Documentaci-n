/**
 * @author Victor San Martin
 */

var base = "";
$A(document.getElementsByTagName("script")).findAll( function(s) {
	if (s.src && s.src.match(/prototype\.js(\?.*)?$/)) {
		base = s.src.replace(/prototype\.js(\?.*)?$/,'');
		throw $break;
	}
});

var Online = {
	refresh: function () {
		new Ajax.Request(base.replace('js/', '') + 'ajax/onlines/index/', {
			onComplete: function (transport) {
				Online.onlines = Number(transport.responseText);
			}
		});
	},
	onlines: 0
}
Online.refresh();

second = 1000;
setInterval("Online.refresh();", (second * 300));