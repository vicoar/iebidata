authorization do
  
  role :administrador do
    includes :autor
    has_permission_on [:categorias, :ciudades, :claves, :colecciones, :ejemplares, :imagenes, :muestras, :muestreos, :paises, :regiones, :sinonimos, :sitios, :referencias, :taxones],
      :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on :usuarios,             :to => [:index, :show, :edit, :update, :destroy]
    has_permission_on :inicio,              :to => :panel
    has_permission_on :authorization_rules, :to => [:read,:change]
    has_permission_on :invitaciones,        :to => [:index, :new, :create, :destroy, :enviar]
  end
  
  role :autor do
    includes :registrado
    has_permission_on [:claves, :colecciones, :ejemplares, :imagenes, :muestras, :muestreos, :sinonimos, :sitios, :referencias, :taxones],
      :to => [:index, :show, :new, :create, :edit, :update]
    has_permission_on :claves,     :to => [:opciones, :cambiar, :seleccionar_imagen, :asignar_imagen]
    has_permission_on :taxones,   :to => [:index, :show, :resumen, :galeria]
    has_permission_on [:muestras, :muestreos, :ejemplares],  :to => [:show, :resumen, :ficha]
    has_permission_on :muestreos,  :to => :select_sitio
    has_permission_on :sitios,     :to => :select_muestra
    has_permission_on :imagenes,   :to => [:ajax_upload, :lista, :ordenar ]
    has_permission_on :paises,     :to => :select_region
    has_permission_on :taxones,    :to => :hijos
  end
  
  role :registrado do
    has_permission_on :inicio,    :to => [:bienvenido, :error]
    has_permission_on :sesiones,  :to => [:index, :destroy]
    has_permission_on :categorias,:to => [:taxones, :autocompletar_taxon]
    has_permission_on :taxones,   :to => [:index, :show, :resumen, :galeria]
    has_permission_on :busquedas, :to => [:new, :create, :show]
    has_permission_on :cuentas,   :to => [:show, :edit, :update]
  end
  
  role :guest do
    has_permission_on :invitaciones, :to => [:new, :create]
    has_permission_on :sesiones,     :to => [:new, :create]
    has_permission_on :cuentas,      :to => [:show, :new, :create]
    has_permission_on :recuperar_cuenta, :to => [:show, :new, :create, :edit, :update]
    has_permission_on :inicio,       :to => [:index, :bienvenido]
    has_permission_on :categorias,:to => [:taxones, :autocompletar_taxon]
    has_permission_on :taxones,   :to => [:index, :show, :resumen, :galeria] do
      if_attribute :visible => true
    end
  end
  
end