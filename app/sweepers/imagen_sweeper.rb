class ImagenSweeper < ActionController::Caching::Sweeper
  
  observe Imagen
  
  include Limpiador
  
  def after_save(imagen)
    limpiar_taxon(imagen) if imagen.album_type == 'Taxon'
  end
  
  def after_destroy(imagen)
    limpiar_taxon(imagen) if imagen.album_type == 'Taxon'
  end
  
  private
  
  def limpiar_taxon(imagen)
    taxon = imagen.album
    expire_action :controller => :taxones, :action => :resumen, :id => taxon.id
    expire_action :controller => :taxones, :action => :galeria, :id => taxon.id, :format => :xml
    expire_fragment %r{taxones/#{taxon.id}/imagenes}
  end
  
end