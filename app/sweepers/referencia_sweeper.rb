class ReferenciaSweeper < ActionController::Caching::Sweeper
  
  observe Referencia
  
  def after_save(referencia)
    limpiar_taxon(referencia.taxon)
  end
  
  def after_destroy(referencia)
    limpiar_taxon(referencia.taxon)
  end
  
  def limpiar_taxon(taxon)
    expire_fragment %r{taxones/#{taxon.id}/referencias}
  end
  
end