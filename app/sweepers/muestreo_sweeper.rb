class MuestreoSweeper < ActionController::Caching::Sweeper
  
  observe Muestreo
  
  include Limpiador
  
  def after_save(muestreo)
  	limpiar_muestreo(muestreo)
    limpiar_taxon(muestreo)
  end
  
  def after_destroy(muestreo)
  	#todos los datos
  	expire_fragment "muestreos/#{muestreo.id}"
    limpiar_taxon(muestreo)
  end
  
  private
  
  def limpiar_muestreo(muestreo)
  	#muestreo en si
  	expire_fragment "muestreos/#{muestreo.id}/show"
  	
  	#sitios
    ids = muestreo.sitios.map(&:id).flatten
    if ids.length > 0
      expire_fragment %r{sitios/(#{ids.join('|')})/show}
    end
  	
  	#muestras
  	ids = muestreo.muestras.map(&:id).flatten
  	if ids.length > 0
  		expire_fragment %r{muestras/(#{ids.join('|')})/show}
  	end
  	
  	#ejemplares
  	ids = muestreo.ejemplares.map(&:id).flatten
  	if ids.length > 0
  		expire_fragment %r{ejemplares/(#{ids.join('|')})/show}
  	end
  end
  
  def limpiar_taxon(muestreo)  	
    ids = muestreo.taxones.map(&:id).flatten
    if ids.length > 0
      expire_fragment %r{taxones/(#{ids.join('|')})/muestreos}
    end
  end
  
end