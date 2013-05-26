class EjemplarSweeper < ActionController::Caching::Sweeper
  
  observe Ejemplar
  
  include Limpiador
  
  def before_update(ejemplar)
  	if ejemplar.taxon_id_changed?
		  limpiar_taxon(ejemplar.taxon_id_was)
  	end
  	if ejemplar.muestra_id_changed?
  	  limpiar_ejemplar(ejemplar)
  	end
  end
  
  def after_save(ejemplar)
    limpiar_ejemplar(ejemplar)
    limpiar_taxon(ejemplar.taxon_id)
  end
  
  def after_destroy(ejemplar)
  	#todos los datos
    expire_fragment "ejemplares/#{ejamplar.id}"
    limpiar_taxon(ejemplar.taxon_id)
  end
  
  private
  
  def limpiar_ejemplar(ejemplar)
    #ejemplar en si mismo
  	expire_fragment "ejemplares/#{ejemplar.id}/show"
  	
  	#muestras
  	expire_fragment "muestras/#{ejemplar.muestra_id}/ejemplares"
  end
  
  def limpiar_taxon(taxon_id)
    expire_fragment %r{taxones/#{taxon_id}/(ejemplares|muestras|muestreos|mapa)}
    
    expire_action :controller => :taxones, :action => :resumen, :id => taxon_id
    expire_action :controller => :taxones, :action => :galeria, :id => taxon_id, :format => :xml
  end
  
end