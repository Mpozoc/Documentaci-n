/**
 * @author vsanmartin
 * @created 2009-10-21 12:16 GMT-4
 */
var Base = {
	/**
	 * emptyOption = Booleano que indica si deja una opción vacía o no (por defecto: true)
	 * 
	 * $('foo').deleteOptions(emptyOption);
	 **/
    deleteOptions: function(element, emptyOption){
        var element = $(element), emptyOption = emptyOption || true;
		element.options.length = 0;
		if (emptyOption) {
			element.options[0] = new Option((typeof(emptyOption) == 'string' ? emptyOption : ''));
		}
		return element;
    },
	/**
	 * data = Objecto de datos (JSON)
	 * selected = Valor por defecto
	 * 
	 * $('foo').optionize(data[, selected]);
	 **/
	optionize: function(element, data, selected, options) {
		var element = $(element), selected = selected || -1, i = 0,
			params = {
				start: function() { },
				end: function() {}
			};
		Object.extend(params, options || { });
		
		params.start();
		for (var key in data) {
			element.options[i + 1] = new Option(data[key], key, (key == selected ? true : false));

			// fixed for IE
			if (key == selected) {
				element.selectedIndex = i + 1;
			}
			i++;
		}
		params.end();
		return element;
	},
	optionizeAjax: function(element, options) {
		var element = $(element),
			params = {
				url: null,
				selected: -1,
				beforeAjax: function() { },
				afterAjax: function() { },
				beforeOptionize: function() { },
				afterOptionize: function() {},
				start: function() { },
				end: function() {}
			};
		Object.extend(params, options || { });
		
		params.beforeAjax();
		new Ajax.Request(
			params.url, 
			{
				onComplete: function(r){
					params.beforeOptionize(r);
					response = r.responseJSON || eval('(' + r.responseText + ')');
					element.optionize(response, params.selected || -1, {start: params.start, end: params.end});
					params.afterOptionize();
				}
			}
		);
		params.afterAjax();
		return element;
	},
	/**
	 * text = Texto por defecto con el que aparecera el nuevo select (por defecto: Otro)
	 * otherDiv = Div que contiene el input text que aparece cuando se selecciona 'Otro' (por defecto busca al div siguiente)
	 * 
	 * $('foo').otherize([text[, otherDiv]]);
	 **/
	otherize: function(element, text, otherDiv, selected) {
		var element = $(element), text = text || 'Otro', i = element.options.length, key = element.name.replace('data[', '').replace('][', '.').replace(']', ''), selected = selected || false;
		var otherDiv = $(otherDiv) || element.up('div').next('div');
		/*if (typeof $data != "undefined") {
			if ((typeof($data[key.split('.')[0]][key.split('.')[1]]) != "undefined")) {
				selected = ($data[key.split('.')[0]][key.split('.')[1]] == -1);
			}
		}*/
		element.options[i] = new Option(text, -1, selected);
		if (selected) { element.selectedIndex = i; }
		
		element.observe('change', function(){
			otherDiv[$(this).getValue() == -1 ? 'show' : 'hide']();
		}).simulate('change');
		return element;
	}
}
Element.addMethods(Base);

/**
 * @author vsanmartin
 * @created 2009-09-04 12:19 GMT-4
 */
var Tip = Class.create({
	initialize: function() {
		$$('a[rel^=tip]').invoke('observe', 'click', this.show.bind());
		$$('a.tipclose[rel]').invoke('observe', 'click', this.close.bind());
	},
	show: function() {
		tip = this.readAttribute('rel').replace('tip[', '').replace(']', '');
		if ($(tip)) {
			$j('#' + tip).fadeIn('slow'); 
		}
	},
	close: function() {
		$j('#' + this.readAttribute('rel')).fadeOut('hide'); 
	}
});

/**
 * Event.simulate(@element, eventName[, options]) -> Element
 * 
 * - @element: element to fire event on
 * - eventName: name of event to fire (only MouseEvents and HTMLEvents interfaces are supported)
 * - options: optional object to fine-tune event properties - pointerX, pointerY, ctrlKey, etc.
 *
 *    $('foo').simulate('click'); // => fires "click" event on an element with id=foo
 *
 **/
(function(){
  
  var eventMatchers = {
    'HTMLEvents': /^(?:load|unload|abort|error|select|change|submit|reset|focus|blur|resize|scroll)$/,
    'MouseEvents': /^(?:click|mouse(?:down|up|over|move|out))$/
  }
  var defaultOptions = {
    pointerX: 0,
    pointerY: 0,
    button: 0,
    ctrlKey: false,
    altKey: false,
    shiftKey: false,
    metaKey: false,
    bubbles: true,
    cancelable: true
  }
  
  Event.simulate = function(element, eventName) {
    var options = Object.extend(Object.clone(defaultOptions), arguments[2] || { });
    var oEvent, eventType = null;
    
    element = $(element);
    
    for (var name in eventMatchers) {
      if (eventMatchers[name].test(eventName)) { eventType = name; break; }
    }

    if (!eventType)
      throw new SyntaxError('Only HTMLEvents and MouseEvents interfaces are supported');

    if (document.createEvent) {
      oEvent = document.createEvent(eventType);
      if (eventType == 'HTMLEvents') {
        oEvent.initEvent(eventName, options.bubbles, options.cancelable);
      }
      else {
        oEvent.initMouseEvent(eventName, options.bubbles, options.cancelable, document.defaultView, 
          options.button, options.pointerX, options.pointerY, options.pointerX, options.pointerY,
          options.ctrlKey, options.altKey, options.shiftKey, options.metaKey, options.button, element);
      }
      element.dispatchEvent(oEvent);
    }
    else {
      options.clientX = options.pointerX;
      options.clientY = options.pointerY;
      oEvent = Object.extend(document.createEventObject(), options);
      element.fireEvent('on' + eventName, oEvent);
    }
    return element;
  }
  
  Element.addMethods({ simulate: Event.simulate });
})();

/**
 * Init All
 */
var $j = jQuery.noConflict();
$j(document).ready(function() { 
	var myTip = new Tip;
	
	if (typeof($j.fn.qtip) != 'undefined') {
		$j('input[title!=""]').qtip({
			content: ' ',
			position: {
				corner: {
					target: 'rightMiddle',
					tooltip: 'leftMiddle'
				}
			},
			style: { 
				name: 'blue',
				tip: true,
				border: {
					radius: 5
				},
				width: 200
			},
			show: {
				solo: true,
				delay: 0,
				effect: {
					type: 'show',
					length: 0
				}
			},
			hide: {
				fixed: true,
				effect: {
					type: 'hide',
					length: 0
				}
			},
			api: {
				beforeShow: function(e) {
					npt = $j(e.target);
					this.elements.content.html(npt.attr('title'));
				}
			}
		});
	}
});

/*
 * jQuery Timer Plugin
 * http://www.evanbot.com/article/jquery-timer-plugin/23
 *
 * @version      1.0
 * @copyright    2009 Evan Byrne (http://www.evanbot.com)
 */ 

jQuery.timer = function(time,func,callback){
	var a = {timer:setTimeout(func,time),callback:null}
	if(typeof(callback) == 'function'){a.callback = callback;}
	return a;
};

jQuery.clearTimer = function(a){

	clearTimeout(a.timer);
	if(typeof(a.callback) == 'function'){a.callback();};
	return this;
};

function formatearRut(casilla){
	function formatearMillones(nNmb){
		var sRes = "";
		for (var j, i = nNmb.length - 1, j = 0; i >= 0; i--, j++)
		 sRes = nNmb.charAt(i) + ((j > 0) && (j % 3 == 0)? ".": "") + sRes;
		return sRes;
	}

	var casillaRut = document.getElementById(casilla);
	var rut = casillaRut.value;
	var ultimoDigito = rut.substr(rut.length-1,1);
	var terminaEnK = (ultimoDigito.toLowerCase() == "k");
	rutSinFormato = rut.replace(/\W/g, "");
	rut = rut.replace(/\D/g, "");
	var dv = rut.substr(rut.length-1,1);
	if (!terminaEnK){ 
		rut=rut.substr(0, rut.length-1); 
	}
	else { 
		dv = "K"; 
	}
	if (rut && dv) {
		casillaRut.value = formatearMillones(rut)+"-"+dv;
	}
} 
