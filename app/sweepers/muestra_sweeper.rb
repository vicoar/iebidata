class MuestraSweeper < ActionController::Caching::Sweeper
  
  observe Muestra
  
  include Limpiador
  
  def after_save(muestra)
  	limpiar_muestra(muestra)
    limpiar_taxon(muestra)
  end
  
  def after_destroy(muestra)
  	#todos los datos
  	expire_fragment %r{muestras/#{muestra.id}}
    limpiar_taxon(muestra)
  end
  
  private
  
  def limpiar_muestra(muestra)
  	#muestra en si misma
  	expire_fragment "muestras/#{muestra.id}/show"
  	
  	#sitios
  	expire_fragment %r{sitios/#{muestra.sitio_id}/muestras}
  	
  	#ejemplares
  	ids = muestra.ejemplares.map(&:id).flatten
  	if ids.length > 0
  		expire_fragment %r{ejemplares/(#{ids.join('|')})/show}
  	end
  end  
  
  def limpiar_taxon(muestra)
    ids = muestra.taxones.map(&:id).flatten
    if ids.length > 0
      expire_fragment %r{taxones/(#{ids.join('|')})/(muestras|mapa)}
    end
  end
  
end