class SitioSweeper < ActionController::Caching::Sweeper
  
  observe Sitio
  
  include Limpiador
  
  def after_save(sitio)
    limpiar_sitio(sitio)
  end
  
  def after_destroy(sitio)
    limpiar_sitio(sitio)
  end
  
  private
  
  def limpiar_sitio(sitio)
    #muestra en si misma
    expire_fragment "sitios/#{sitio.id}/show"
    
    #muestro
    expire_fragment %r{muestreos/#{sitio.muestreo_id}/sitios}
    
    #muestras
    ids = sitio.muestras.map(&:id).flatten
    if ids.length > 0
      expire_fragment %r{muestras/(#{ids.join('|')})/show}
    end
    
    #ejemplares
    ids = sitio.ejemplares.map(&:id).flatten
    if ids.length > 0
      expire_fragment %r{ejemplares/(#{ids.join('|')})/show}
    end
  end
  
end