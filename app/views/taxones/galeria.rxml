
  xml.instruct!                   
  xml.simpleviewergallery( "galleryStyle" => "COMPACT", "thumbColumns" => "6", "thumbRows" => "1",  "thumbPosition" => "TOP", "showOpenButton" => "TRUE", 
  "imageScaleMode" => "SCALE_UP", "showFullscreenButton" => "TRUE", "frameWidth" => "0", "maxImageWidth" => "1600", "maxImageHeight" => "1200") {
  
  	@imagenes.each do |imagen|
		xml.image( "imageURL" => image_path(imagen.url(:med)), "thumbURL" => image_path(imagen.url(:min)), "linkURL" => imagen_path(imagen) ) {
			xml.caption(imagen.comentario ? imagen.comentario : '<i>Sin comentario</i>')
		}
	end
	                      
  }   