class CategoriaSweeper < ActionController::Caching::Sweeper
  
  observe Categoria
  
  include Limpiador
  
  def after_save(categoria)
    limpiar_categoria
  end
  
  def after_destroy(categoria)
    limpiar_categoria
  end
  
  private
  
  def limpiar_categoria
    expire_fragment "menu"
    expire_fragment %r{taxones}
  end
  
end