class TaxonSweeper < ActionController::Caching::Sweeper
  
  observe Taxon
  
  include Limpiador
  
  def before_update(taxon)
    if taxon.categoria_id_changed? || taxon.parent_id_changed?
      limpiar_taxon(taxon, taxon.parent_id_was, taxon.categoria_id_was)
    end
  end
  
  def after_save(taxon)
    limpiar_taxon(taxon)
    limpiar_asoc(taxon)
  end
  
  def after_destroy(taxon)
  	#todos los datos
    expire_fragment "taxones/#{taxon.id}"
    limpiar_taxon(taxon)
    limpiar_asoc(taxon)
  end
  
  private
  
  def limpiar_taxon(taxon, padre_id = nil, categoria_id = nil)
    #taxon en si mismo
    expire_fragment "taxones/#{taxon.id}/show"
    
    #borro el resumen (por si cambia el nombre)
    expire_action :controller => :taxones, :action => :resumen, :id => taxon.id
    
    categoria_id = categoria_id || taxon.categoria_id
    categoria = Categoria.find categoria_id
    
    #borro el autocompletar
    expire_fragment %r{categorias/(#{categoria_id}|0)/autocompletar_taxon}
    
    #borro de la lista de taxones en categoria
    expire_fragment %r{categorias/#{categoria.id}}
    
    if categoria.final?
      #si la categoria final => borro en todos los ancestros
      ids = taxon.ancestors.map(&:id).flatten
      if ids.length > 0
      	expire_fragment %r{taxones/(#{ids.join('|')})/subcategorias}
        expire_fragment %r{taxones/(#{ids.join('|')})/subcat/#{categoria_id}}
      end
    end
    
    padre_id = padre_id || taxon.parent_id
    
  	if padre_id
  	    #solo el padre
  	    expire_fragment %r{taxones/#{padre_id}/subcategorias}
  	    expire_fragment %r{taxones/#{padre_id}/subcat/(#{categoria_id}|0)}
  	else
	    #no tiene padre, lo borro de los raices
	    expire_fragment %r{categorias/0}
  	end
    
    #borro los hijos (por el breadcrumb)
    ids = taxon.descendants.map(&:id).flatten
    if ids.length > 0
    	expire_fragment %r{taxones/(#{ids.join('|')})/show}
    end
    
    #si hace a todos los hijos visibles borro sus indices
    if taxon.aplicar_visibilidad_a_hijos_y_padres
      ids = taxon.ancestors.map(&:id).flatten
      expire_fragment %r{taxones/#{ids.join('|')}/subcat}
      
      ids = taxon.self_and_descendants.map(&:id).flatten
      expire_fragment %r{taxones/#{ids.join('|')}/subcat}
      
      expire_fragment %r{/categorias}
    end
    
  end
  
  def limpiar_asoc(taxon)
    #ejemplares
    ids = taxon.ejemplares.map(&:id).flatten
    if ids.length > 0
    	expire_fragment %r{ejemplares/(#{ids.join('|')})/show}
   	end
    
    #muestras
    ids = taxon.muestras.map(&:id).flatten
    if ids.length > 0
    	expire_fragment %r{muestras/(#{ids.join('|')})/ejemplares}
    end
  end
  
end