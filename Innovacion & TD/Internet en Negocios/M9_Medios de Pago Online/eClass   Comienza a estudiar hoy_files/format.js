function FormatJS(){
	this.formatNum = function(obj,e){
		var cadena = obj.value;
		var key = e.charCode? e.charCode : e.keyCode;
		
		if (key != 37 && key != 39 ){
		
			var tmpstr = '';
			
			for(i=0;i<cadena.length;i++){
				if (cadena.charAt(i).match(/^[0-9]*$/))
					tmpstr = tmpstr + cadena.charAt(i);
			}	
			obj.value = tmpstr;		
		}
		return;
	}
	
	this.timeFormat = function(obj,e){
		var time = obj.value;
		var key = e.charCode? e.charCode : e.keyCode;
		if (key != 37 && key != 39 )
		{
			var tmpstr = '';
			time = time.replace(":","");
			for ( i=0; (i < time.length); i++ ){
				if((time.charAt(i) || time.charAt(i) == ":") && i < 4){
					if(i%2 == 0 && i != 0)
					tmpstr = tmpstr + ":" +time.charAt(i);
					else
					tmpstr = tmpstr + time.charAt(i);
				}
			}
			obj.value = tmpstr;
		}
	}
	

	this.formatRut = function(obj,e){
	
	/****************************************/
	// Formatea el rut

		var rut = obj.value;
		var key = e.charCode? e.charCode : e.keyCode;
		
		if (key != 37 && key != 39 )
		{
			var tmpstr = '';
	
		  	for ( i=0; i < rut.length ; i++ ){
				if (( rut.charAt(i) >= 0 && rut.charAt(i)<=9) || ((rut.charAt(i)=='k' || rut.charAt(i)=='K')) && rut.length == i+1) {
					tmpstr = tmpstr + rut.charAt(i);
				}
			}
			rut = tmpstr;
			obj.value = rut;
			tmpstr = '';
			largo = rut.length;
			if (largo>1){
				var invertido = '';
				for ( i=(largo-1),j=0; i>=0; i--,j++ )
				  invertido = invertido + rut.charAt(i);
				var drut = '';
				drut = drut + invertido.charAt(0);
				drut = drut + '-';
				cnt = 0;
				for ( i=1,j=2; i<largo; i++,j++ ){
				  if ( cnt == 3 ){
					drut = drut + '.';
					j++;
					drut = drut + invertido.charAt(i);
					cnt = 1;
				  } else {
					drut = drut + invertido.charAt(i);
					cnt++;
				  }
				}
				invertido = '';
				for ( i=(drut.length-1),j=0; i>=0; i--,j++ )
				  invertido = invertido + drut.charAt(i);
			
				obj.value = invertido;  
				if (obj.selectionStart<drut.length) obj.selectionStart = drut.length;
			} else {
				obj.value = rut; 
			}
		}

	/******************************************/	
	}
}

var Formato = new FormatJS();

