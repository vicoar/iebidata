class SinonimoSweeper < ActionController::Caching::Sweeper
  
  observe Sinonimo
  
  def after_save(sinonimo)
    limpiar_taxon(sinonimo.taxon)
  end
  
  def after_destroy(sinonimo)
    limpiar_taxon(sinonimo.taxon)
  end
  
  def limpiar_taxon(taxon)
    expire_fragment %r{taxones/#{taxon.id}/sinonimos}
  end
  
end