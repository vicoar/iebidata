module Limpiador
  
  
  ##################
  
  def limpiar(objeto,controlador = nil, indice = true)
    #previene que el objeto venga vacio (pasa cuando un objeto nuevo detecta que tiene un padre viejo en nil)
    return false unless objeto
    #si el objeto es un id, entonces el controlador tiene que venir dado y al reves
    if controlador && objeto.kind_of?(Integer)
      id = objeto
    else
      id = objeto.id
      controlador = objeto.class.table_name
    end
    expire_action :controller => controlador, :action => :show, :id => id
    paginas("#{controlador}/#{id}") #paginas propias
    if indice
      expire_action :controller => controlador, :action => :index
      paginas(controlador) #paginas del index
    end
  end
  
  
  def limpiar_padre(objeto, metodo, indice = false)
    controlador = objeto.send(metodo).class.table_name
    if objeto.send(metodo + '_id_changed?')
       padre_anterior = objeto.send(metodo + '_id_was')
       limpiar(padre_anterior, controlador, indice)
    end
    padre_nuevo = objeto.send(metodo + '_id')
    limpiar(padre_nuevo, controlador, indice)   
  end
 
  
  def limpiar_hijos(hijos, controlador = nil, indice = false)
    controlador = hijos.first.class.table_name unless controlador
    hijos.each do |hijo|
      limpiar(hijo, controlador, indice)
    end
  end
  
  
  def paginas(nombre)
    #previene que el objeto venga vacio (pasa cuando un objeto nuevo detecta que tiene un padre viejo en nil)
    return false unless nombre
    expire_fragment %r{/#{nombre}/p/\d*}
  end
  
end