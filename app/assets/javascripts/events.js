/* http://stackoverflow.com/questions/2161159/get-script-path */
var base = $('script[src*="events"]').attr('src').split('?')[0];
base = base.split('/').slice(0, -1).join('/')+'/';

var js = {
	cookie : base + "cookie-flash-rails.js"
  , jqueryui : "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/jquery-ui.min.js"
  , rails : base + "rails.js"
  , swfobject: "http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"
  , simpleviewer : base + "simpleviewer/simpleviewer.swf"
}


$(function(){

	/********************** FLASH **********************/
	Flash.transferFromCookies();
	Flash.writeDataTo('notice', $('#flash .notice'));
	Flash.writeDataTo('alert', $('#flash .error'));
	
    $('#flash .ver').slideDown();
    $('#flash div .close').click(function(){
		$('#flash .ver').slideUp();
		return false;
    });
	
	var botones = $('button, .button').filter(':hidden');
	var tipo = Cookie.get("usuario_tipo");
	
	if (tipo == "administrador"){
		botones.addClass('visible');
		$('.admin').show();
	}
	if (tipo == "administrador" || tipo == "autor"){
		botones.filter(':not(.red)').addClass('visible');
		$('.autor').show();
	}
	// se ejecuta lo mismo otra vez porque jquery una vez capturados 
	// los elementos no los actualiza automaticamente
	$('button, .button').filter(':hidden').remove();

	
	/******************** BUSCADOR ********************/
	$('#busqueda_nombre').bind('focus change',function(){
		autocompletar('#busqueda_nombre','#busqueda_categoria_id',function(event,ui){
			if(ui.item){
				window.location = "/taxones/" + ui.item.id;
		    }
    	});
	});
	
	
	/********************** MENU **********************/

	menu($('#nav')); 
	$('#categoria_especie').attr('checked','checked');
	$('#filtro').val('Especie');
	dropdown($("ul.dropdown li"));
	$('.categorias a').click(function(){
		var i = $(this).find('input');
		i.attr('checked','checked');
		$('#filtro').val(i.val());
		return false;
	})
	$('.categorias input:radio').click(function(){
		$(this).parent('a').click();
		return false;
	});
	
	
	/******************** FORMULARIO ********************/
	
	$('input,textarea,select').focus(function(){
		var fila = $(this).parents("tr");
		fila.find('label').addClass("focus");
		$(this).addClass("focus");
	}).blur(function(){
		var fila = $(this).parents("tr");
		fila.find('label').removeClass("focus");
		$(this).removeClass("focus");
	});
	
	
	/******************* BREADCRUMBS *******************/
	
	$("#breadcrumb").delegate('.dir','mouseover',function(){
		$(this).addClass("open");
		$(this).find('ul:first').css('visibility', 'visible');
	});
	
	$("#breadcrumb").delegate('.dir','mouseout',function(){
		$(this).removeClass("open");
		$(this).find('ul:first').css('visibility', 'hidden');
	})
	
	ocultar();
	$(window).bind('resize',ocultar);
	
	/********************** iMENU **********************/
	
	if($('.imenuui').length > 0){
		$('.imenuui li a').addClass('arrow');
		
		$('.imenuui li:first-child').addClass('first');
		$('.imenuui li:last-child').addClass('last');
		$('.imenuui li:only-child').removeClass('first last').addClass('single');
		
		$('.imenuui li').hover(function(){
			$(this).addClass('active');
		}, function(){
			$(this).removeClass('active');
		});
	}	
	
	/********************* FIELDSET *********************/
	$('fieldset.colapsable').each(function(){
		var fs = $(this);
		fs.wrapInner('<div class="cont" />');
		var cont = fs.find('> .cont');
		var etiq = cont.find('> legend').detach();
		fs.prepend(etiq);
		cont.hide();
	})
	$('fieldset.colapsable > legend').click(function(){
	    $(this).next('.cont').toggle('slow');
	});
	
	
	/******************* RECORDARME *********************/
	$('#usuario_session_remember_me').change(function(){
		var chbox = $(this);
		if (chbox.is(':checked')){
			var resp = confirm("Por seguridad no active esta opcion en computadoras compartidas con otras personas.\n ¿Desea continuar?");
			chbox.attr('checked', resp);
		}
	});
	
	/********************* GALERIA *********************/
	
	if($('#galeria').length > 0){
		galeria();
	}
	
	$(window).bind('resize',function(){
		if($('#galeria').length > 0){
			var gal = $('#galeria')
			  , ancho = gal.closest('fieldset').innerWidth();
			gal.attr('height', ancho*3/4 );
		}
	});
	
	
	/********************** TABLA **********************/
	
	if($('table.zebra').length > 0){
		$('table.zebra').each(function(){
			$(this).find('th').parent('tr').addClass('cabecera');
			$(this).find('tr:nth-child(odd)').addClass('impar');
		});
		
		$('table.zebra tr:not(.cabecera)').hover(function(){
			$(this).addClass('active');
		}, function(){
			$(this).removeClass('active');
		});
	}
	if($('table.fields').length > 0){
		$('table.fields tr td:first-child').addClass('label');
	}
	
	
	/********************** MAPA **********************/
	
	//eventos_mapas();
	
	
	/****************** LISTAS AJAX *******************/
	
	$('#listaTaxones a').click(function(){
		var link = $(this);
		var parent = link.parent('li');
		if(!parent.hasClass('showing')){
			link.addClass('loading');
			
			$.ajax({
				url:$(this).attr('href') + '/resumen',
				success: function(data){
					link.removeClass('loading');
					$('#listaTaxones li').removeClass('showing');
					parent.addClass('showing');
					
					$('#taxon').html(data);
					galeria();
				},
				error:function(data){
					$('#taxon').html(data);
					link.removeClass('loading');
				}
			});
		}
		return false;
	});
	
	$('#muestreos .imenuui a').click(function(){
		var link = $(this);
		var parent = link.parent('li');
		if (!parent.hasClass('showing')) {
			link.addClass('loading');
			$.ajax({
				url: $(this).attr('href'),
				success: function(data){
					link.removeClass('loading');
					$('#listaMuestras li').removeClass('showing');
					parent.addClass('showing');
					
					var contenido = $(data).find('.contenido');
					var verMas = $('<a>').addClass('button gray mas')
						.attr('href',link.attr('href'))
						.text('Ver mas');
					contenido.append(verMas);					
					
					$('#muestreo').html(contenido);
					$('#muestreo').find('.button:not(.mas)').remove();
					
					galeria();
				},
				error:function(data){
					$('#muestreo').html(data);
					link.removeClass('loading');
				}
			});
		}
		return false;
	});
	
	
	/****************** SELECTS AJAX *******************/	
	
	$('#ejemplar_muestreo_id').change(function(){
		var id = $(this).val();
		$('#select_sitio, #select_muestra').empty();
		if(!isNumeric(id)){
			return false;
		}
		var sel = $('#select_sitio');
		sel.addClass('loading');
		$.ajax({
			url:'/muestreos/' + id + '/select_sitio',
			success:function(data){
				sel.removeClass('loading').html(data);
				/* Carga muestras para el sitio recien cargado si hay sitios */
				if ($('#ejemplar_sitio_id option').length > 0){
					$('#ejemplar_sitio_id').change();
				}
			},
			error:function(){
				sel.removeClass('loading');
				alert('Se produjo un error. Por favor reintente');
			}
		})
	});
	
	$('#ejemplar_sitio_id').on('change',function(){
		var id = $(this).val();
		var sel = $('#select_muestra');
		sel.addClass('loading').empty();
		$.ajax({
			url:'/sitios/' + id + '/select_muestra',
			success:function(data){
				sel.removeClass('loading').html(data);
			},
			error:function(){
				sel.removeClass('loading');
				alert('Se produjo un error. Por favor reintente');
			}
		})
	});
	
	/********************** EJEMPLAR **********************/
	
	function sumar(){
		var suma = 0;
		$('#ejemplar_machos, #ejemplar_hembras, #ejemplar_inmaduros, #ejemplar_indeterminados').each(function(){
			if (! isNaN($(this).val()) ){
				suma = suma + parseInt($(this).val(),10);				
			}
		})
		$('#ejemplar_total').text(suma);
	}
	
	$('#ejemplar_machos, #ejemplar_hembras, #ejemplar_inmaduros, #ejemplar_indeterminados').change(function(){
		sumar();		
	});
	sumar();
	
	$('#ejemplar_coleccion_id').change(function(){
		var num = $("#ejemplar_coleccion_id option:selected").text().split(" - ")[0];
		$("#coleccion_numero").text(num);
	});
	
	$('#ejemplar_coleccion_id').change();
	
	$('#copiar').submit(function(){
	    var ficha = $('.ficha:first').clone();	    
	    var cantidad = $('#copias').val();
	    $('#fichas').empty();
	    for(var i=0; i<cantidad; i++){
	      $('#fichas').append(ficha.clone());
	    }
	    return false;
	});
	
	
	/*********************** IMAGEN **********************/
	
	if($('#new_imagen').length > 0){
		cargador('#new_imagen');
	}
	
	$('a.eliminar').click(function(){
		$(this).parent('.imagen').remove();
		return false;
	});
	
	if($('#ordenable').length > 0){
		$('#ordenable').sortable({
			revert: true,
			update: function(event, ui) {
				var ids = "";					  
				$('#ordenable div').each(function(){
					ids = ids + $(this).data('imagen-id') + ",";
				});
				$('#orden').val(ids);
			}
		});
		$("#ordenable").disableSelection();
	}
	
	/*********************** CLAVE **********************/
	
	$('#agregar_opcion').click(function(){
		var opc = $('.opcion.hidden').clone().removeClass('hidden');
		$('#opciones').append(opc);
		return false; 
	});
	
	$('#opciones .eliminar').on('click', function(){
		var opc = $(this).parents('tr');
		opc.remove();
		return false; 
	});
	
	$('#taxon_id').change(function(){
		var ruta = $('#ruta').val();
		window.location = ruta + '/' + $(this).val();
	});
	
});

/*********************************************************/
/********************** REPLACE ALL **********************/
/*********************************************************/

String.prototype.replaceAll = function(pattern, replacement) {
    var result = '', source = this, match;

    while (source.length > 0) {
      if (match = source.match(pattern)) {
        result += source.slice(0, match.index);
        result += (replacement || '').toString();
        source  = source.slice(match.index + match[0].length);
      } else {
        result += source, source = '';
      }
    }
    return result;
}


/*********************************************************/
/************************** MENU *************************/
/*********************************************************/

function menu(bc){
	bc.find('> li:first').addClass('first');
	bc.find('> li:last').addClass('last');
	bc.find('> li').each(function(){
		var sub = $(this);
		if(sub.find('> ul').length > 0){
			if(sub.find('> a').length > 0){
				sub.find('> a').addClass('dir');
			} else {
				sub.addClass('dir');
			}
			menu(sub.find('> ul'));
		}
	})
}

function ocultar(){
	var bc = $('#breadcrumb');
	if(bc.height() > 30){
		if(bc.find('.dir').length == 0){
			bc.find('> li:first').after(
				$('<li class="dir"> <a href=#">...</a> <ul></ul> </li>')
			)
		}
		var sub = bc.find('.dir');
		var menu = sub.find('ul');
		while(bc.height() > 30){
			var item = sub.next('li');
			menu.append(item.clone());
			item.remove();
		}
	} else {
		if(bc.find('.dir').length > 0){
			var sub = bc.find('.dir');
			var menu = sub.find('ul');
			var item = menu.find('li:last');
			if(item.length > 0){
				sub.after(item.clone());
				item.remove();
				ocultar();
			} else {
				sub.remove();
			}
		}
	}
}

/*********************************************************/
/************************ DROPDOWN ***********************/
/*********************************************************/

function dropdown() {

	$(this).hover(function(){
		$(this).addClass("hover");
		$('> .dir',this).addClass("open");
		$('ul:first',this).css('visibility', 'visible');
	},function(){
		$(this).removeClass("hover");
		$('.open',this).removeClass("open");
		$('ul:first',this).css('visibility', 'hidden');
	});

}


/*********************************************************/
/************************** MAPA *************************/
/*********************************************************/

/*function eventos_mapas(){
    
}*/

/*********************************************************/
/******************** CARGADOR PLUPLOAD ******************/
/*********************************************************/

function cargador(id){
	var baseplu = base + "plupload/"
	  , multiples = false
	  , tipoAlbum = $('#imagen_album_type').val();
	multiples = (tipoAlbum == "Taxon");
	

   	$('#instrucciones').removeClass('hidden');
	
	$(id).pluploadQueue({
		// General settings
		runtimes : 'flash,silverlight',
		url : "/imagenes/ajax_upload",
		// max_file_size : '2mb',
		filters : [
			{title : "Imagen JPEG", extensions : "jpg"},
			{title : "Otros formatos de Imagen", extensions : "gif,png"}
		],
		multipart: true,  
		multipart_params: {  
	    "authenticity_token" : $('meta[name="csrf-token"]').attr('content'),
			"album_id":  $('#new_imagen #imagen_album_id').val(),
			"album_type":$('#new_imagen #imagen_album_type').val()
	   	},
		
		// Si es clave evito que seleccione varios archivos
		multi_selection: multiples,

		// Resize images on client side if we can
		// El tamaño es un poco mayor al que se usa porque PLUpload pixela los bordes
		// al cambiar de tamaño, por ello se vuelve a cambiar el tamaño en el servidor
		resize : {width : 1200, height : 900, quality : 80},

		// Flash & Silverlight settings
		flash_swf_url : baseplu + 'plupload.flash.swf',
		silverlight_xap_url : baseplu + 'plupload.silverlight.xap'
	});
	
	var uploader = $(id).pluploadQueue();
	
	uploader.bind('UploadComplete', function() {
		var texto = $('#link a').text();
		if( confirm('Carga finalizada: ' + texto + '?') ){
			var link = $('#link a').attr('href');
			window.location = link;
		}	
		preguntar = false;	
  	});
	
	//Si es para una clave envia el archivo apenas se lo selecciono
	if(!multiples){
		uploader.bind('FilesAdded', function(up, files) {
	        if(uploader.state!=2 & files.length>0){
	        	uploader.start();
	        }
		});
	}
	
}


/*********************************************************/
/************************ GALERIA ************************/
/*********************************************************/

function galeria(){	
	if ($('#galeria').length > 0) {
		var back = "eeeeee"			
		var gal = $('#galeria'), ancho = gal.closest('fieldset').innerWidth(), alto = ancho * 3 / 4;			
		var docXml = $('#galeriaXml').val() + ".xml";
		
		var flashvars = {};
		flashvars.galleryURL = docXml;
		var params = {};
		params.allowfullscreen = true;
		params.allowscriptaccess = "always";
		params.bgcolor = back;
		swfobject.embedSWF( js.simpleviewer, "galeria", "100%", alto, "9.0.124", false, flashvars, params );
		
	}
}

/*********************************************************/
/**************** AUTOCOMPLETADO DE TAXON ****************/
/*********************************************************/

var cache = new Object;

function autocompletar(selector, categoria, callback){
	// callback on select
	if(typeof(callback) != "function"){
		callback = function(event,ui){};
	}
	
	// selector: campo de texto que se autocompletara
	// categoria: categoria del taxon
	// fk: lleva el ID en caso que sirva para establecer una relacion (p.e. #ejemplar_taxon_id
	var campo = $(selector)
	  , fk = $(selector + "_id")
	  , categoria = $(categoria);
	
	// Para el error de escape de HTML en la etiquetas:
	// http://www.arctickiwi.com/blog/jquery-autocomplete-labels-escape-html-tags
	$[ "ui" ][ "autocomplete" ].prototype["_renderItem"] = function( ul, item) {
		return $( "<li></li>" ) 
		    .data( "item.autocomplete", item )
		    .append( $( "<a></a>" ).html( item.label ) )
		    .appendTo( ul );
	};
    
    
	campo.autocomplete({
		minLength: 2,
		delay: 50,
		search: function(event, ui){
			if (!callback) {
				fk.val('');
			}
		},
		source: function(request, response){
			var cadena = request.term
			  , categoria_id = categoria.val()
			  , items = false;
			
			if(categoria_id == ""){
				categoria_id = 0;
			}
			
			/* Cache: matriz [categoria,cadena] en forma de objetos */
			if (categoria in cache) {
				if (cadena in cache[categoria]) {
					items = cache[categoria][cadena];
				}
			}
			else {
				cache[categoria] = new Object;
			}
			
			if (items) {
				response(items);
			}
			else {
				$.getJSON("/categorias/" + categoria_id + "/autocompletar_taxon/" + cadena + ".json", function(data){
					items = new Array;
					for (var i = 0; i < data.length; i++) {
						taxon = data[i].taxon;
						resaltado = __highlight(taxon.nombre, cadena);
						items[i] = {
							label: resaltado,
							value: taxon.nombre,
							id: taxon.id
						}
					}						
					cache[categoria][cadena] = items;
					response(items);
				});
			}
		},
		select: function(event, ui){
			callback(event,ui);
		}
	});
}


/*********************************************************/
/*********************** HIGHLIGHT ***********************/
/*********************************************************/

function __highlight(s, t) {
  var matcher = new RegExp("("+$.ui.autocomplete.escapeRegex(t)+")", "ig" );
  return s.replace(matcher, "<b>$1</b>");
}

/*********************************************************/
/*********************** ISNUMERIC ***********************/
/*********************************************************/
/* http://stackoverflow.com/questions/18082/validate-numbers-in-javascript-isnumeric */

function isNumeric(input) {
   return (input - 0) == input && input.length > 0;
}