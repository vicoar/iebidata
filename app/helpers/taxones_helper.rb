module TaxonesHelper
  
  def breadcrums(taxon = nil)
    salida = "<ul id='breadcrumb'><li>" + link_to(raw(image_tag("breadcrumb/home.png", :class => "home")), taxones_path)+ "</li>"
    
    if taxon
      # si el taxon es nuevo no puedo acceder directo a los ancestros hasta que este guardado,
      # por ello accedo a los ancestros del padre (si lo tuviera)
      if taxon.new_record? && taxon.parent
        ancestros = taxon.parent.self_and_ancestors
      else
        ancestros = taxon.ancestors
      end
      
      ancestros.includes(:categoria).each do |ancestro|
        salida = salida + "<li>" + link_to("#{ancestro.categoria.nombre}: #{ancestro.nombre}", ancestro) + "</li>"
      end
      
      #agrego el taxon actual
      if taxon.categoria && !taxon.new_record?
        salida = salida + "<li>" + link_to("#{taxon.categoria.nombre}: #{taxon.nombre}", taxon) + "</li>"
      else
        salida = salida + "<li>" + link_to("Nuevo taxon", "#") + "</li>"
      end
    end
    
    salida + "</ul>"
  end
  
  def padre_taxon(mover = nil)
    class_or_item = Taxon.roots
    items = Array(class_or_item)
    result = []
    cat_final = Categoria.final
    items.each do |root|
      result += root.self_and_descendants.where("categoria_id != ?", cat_final.id).map do |i|
        if mover.nil? || mover.new_record? || mover.move_possible?(i)
          [yield(i), i.id]
        end
      end.compact
    end
    result
  end
  
end
