Iebidata::Application.routes.draw do

  scope(:path_names => { :new => "nuevo", :edit => "editar" }) do
    
    resources :categorias do
      resources :taxones do
        collection do
          get 'p/:page', :action => 'index'
        end
      end
      
      member do
        get 'autocompletar_taxon/:cadena', :action => :autocompletar_taxon
      end
    end
    
    resources :taxones do
      member do
        get :resumen
        get :galeria
        get :hijos
        get ':asoc(/p/:page)', :action => :show, :asoc => /muestreos|muestras|ejemplares|imagenes|mapa/
        get 'subcat/:categoria(/p/:page)', :action => :show
      end
      
      resources :sinonimos
      
      resources :referencias
      
      resources :ejemplares, :only => [:new, :create]
      
      resources :imagenes do
        collection do
          get  :lista
          put  :ordenar
        end
      end
      
      resources :taxones, :only => [:new, :create]
    end
    
    match ':controller/p/:page',     :action => 'index'
    match ':controller/:id/p/:page', :action => 'show'
    
    resources :sinonimos
    
    resources :referencias
    
    resources :busquedas    
    
    resources :usuarios
    
    match '/ingresar' => 'sesiones#new',     :as => :login
    match '/salir'    => 'sesiones#destroy', :as => :logout
    
    match '/cuenta/nuevo/:pase' => 'cuentas#new', :as => :inscribir
    resource :cuenta    
    
    resources :invitaciones do
      member do
        post :enviar
      end
    end
    
    resources :recuperar_cuenta,
      :only => [:new, :create, :edit, :update]
    
    resource :sesiones
    
    resources :paises do
      resources :regiones, :only => [:new, :create]
    end
    
    resources :regiones do
      resources :ciudades, :only => [:new, :create]
    end
    
    resources :muestreos do
      resources :sitios, :only => [:new, :create]
      
      member do
        get :select_sitio
      end
    end
    
    resources :sitios do
      resources :muestras, :only => [:new, :create]
      
      member do
        get :select_muestra
      end
    end
    
    resources :muestras do
      resources :ejemplares, :only => [:new, :create]
    end
      
    resources :colecciones do
      resources :ejemplares, :only => [:new, :create]
    end
    
    resources :ejemplares do
      member do
        get :ficha
      end
    end
    
    resources :claves do
      resource :imagen, :only => [:new, :create]
      
      member do
        get :opciones
        put :cambiar
        put :asignar_imagen
        get 'seleccionar_imagen(/:taxon_id)', :action => :seleccionar_imagen, :as => :seleccionar_imagen
      end
    end
    
    resources :imagenes do
      collection do
        post 'ajax_upload', :action => :ajax_upload, :as => :ajax_upload
      end
    end
    
    match '/panel' => 'inicio#panel', :as => :panel
    
    match '/error' => 'inicio#error', :as => :error
    
    #match ':controller(/:action(/:id(.:format)))'
  end

  root :to => "inicio#bienvenido"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
