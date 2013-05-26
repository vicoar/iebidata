module ImagenesHelper
  
  def album_path(imagen)
    if imagen.album_type == "Clave"
      metodo = :clave_path
    else
      metodo = :taxon_imagenes_path
    end
    send(metodo, imagen.album)
  end
  
  def lista_path(imagen)
    param = imagen.album_type.downcase + "_id"
    imagenes_path(param => imagen.album_id)
  end
  
end
