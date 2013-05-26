class RegionSweeper < ActionController::Caching::Sweeper
  
  observe Region, Pais
  
  include Limpiador
    
  def after_save(region)
    limpiar_sitios(region)
  end
  
  def after_destroy(region)
    limpiar_sitios(region)
  end
  
  private
  
  def limpiar_sitios(registro)
  	ids = registro.sitios.map(&:id).flatten
  	if ids.length > 0
  		expire_fragment %r{sitios/(#{ids.join('|')})/show}
  	end
  end
  
end