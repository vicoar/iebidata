class UsuarioSweeper < ActionController::Caching::Sweeper
  
  observe Usuario
  
  include Limpiador
  
  def after_save(usuario)
    limpiar_taxon(usuario)
    limpiar_asoc(usuario)
  end
  
  def after_destroy(usuario)
    limpiar_taxon(usuario)
    limpiar_asoc(usuario)
  end
  
  private
  
  def limpiar_taxon(usuario)
  	ids = usuario.taxones.map(&:id).flatten
  	if ids.length > 0
    	expire_fragment %r{taxones/(#{ids.join('|')})/show}
   	end
  end
  
  def limpiar_asoc(usuario)
  	[:ejemplares, :muestras, :sitios, :muestreos].each do |asoc|
		  limpiar_otros(usuario, asoc)
  	end
  	
  	[:muestras_identificadas, :muestras_colectadas].each do |asoc|
  		limpiar_otros(usuario, asoc, :muestras)
  	end
  end
  
  def limpiar_otros(usuario, asoc, contr = false)
  	ids = usuario.send(asoc).map(&:id).flatten
  	contr = contr || asoc
  	if ids.length > 0
  		expire_fragment %r{#{contr}/(#{ids.join('|')})/show}
  	end  	
  end
  
end