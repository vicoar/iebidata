# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { page_title } 
  end
  
  def button_link(*args, &block)
    if block_given?
      options = args.first || {}
      color   = args.second
      
      link_to(capture(&block), options, { :class => "button #{color}" })
    else
      name    = args.first
      options = args.second || {}
      color   = args.third
       
      link_to(name, options, { :class => "button #{color}" })         
    end
  end
  
  def delete_button(obj, pregunta = 'Estas seguro?')
    link_to 'Eliminar', obj, :confirm => pregunta, :method => :delete, :class => "button red"
  end
  
  def mapa_editable(obj)
    gmaps({ "map_options" => {"zoom" => 10, "auto_zoom" => false}, "markers" => { "data" => (obj.to_gmaps4rails), "options" => {"draggable" => true} } }) 
  end
  
  def mapa(obj)
    gmaps("markers" => { "data" => (obj.to_gmaps4rails) } )
  end
  
end
