module ClavesHelper
  
  def dilema_anterior(mover = nil)
    class_or_item = Clave.roots
    items = Array(class_or_item)
    result = []
    items.each do |root|
      result += root.self_and_descendants.all(:conditions => "taxon_id IS NULL").map do |i|
        if mover.nil? || mover.new_record? || mover.move_possible?(i)
          [yield(i), i.id]
        end
      end.compact
    end
    result
  end 
  
  def breadcrums_clave(clave)
    salida = "<ul id='breadcrumb'><li>" + link_to(raw(image_tag("breadcrumb/home.png", :class => "home")), claves_path)+ "</li>"
    
    if clave
      if clave.new_record? && clave.parent
        ancestros = clave.parent.self_and_ancestors
      else
        ancestros = clave.ancestors
      end
      
      ancestros.where("taxon_id IS NULL AND taxon_nombre IS NULL")
      
      ancestros.each do |ancestro|
        salida = salida + "<li>" + link_to(ancestro.dilema, clave_path(ancestro)) + "</li>"
      end
      
      if clave.new_record?
        salida = salida + "<li>" + link_to("Nuevo clave", "#") + "</li>"
      else
        salida = salida + "<li>" + link_to(clave.dilema, clave_path(clave)) + "</li>"
      end
    end
    
    salida + "</ul>"
  end
  
  def fields_for_child(child, &block)
    prefix = child.new_record? ? 'new' : 'existing'
    fields_for("clave[#{prefix}_child_attributes][]", child, &block)
  end
  
end
