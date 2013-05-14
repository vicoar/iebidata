class Busqueda < ActiveRecord::Base
  
  belongs_to :categoria
  
  validates_presence_of :nombre, :usuario_id
  
  validates_length_of :nombre,
    :minimum => 2
  
  attr_accessible :usuario_id, :nombre, :categoria_id
  
  def taxones
    @taxones = Taxon
    
    unless nombre.blank?
      @taxones = @taxones.where(["nombre LIKE ?", "%#{nombre}%"])
    end
    
    unless categoria_id.blank?
      @taxones = @taxones.where(:categoria_id => categoria_id)
    end
    
    return @taxones.all
  end
  
  def sinonimos
    @sinonimos = Sinonimo
    
    unless categoria_id.blank?
      categoria = Categoria.find categoria_id
      @sinonimos = categoria.sinonimos.where(["sinonimos.nombre LIKE ?", "%#{nombre}%"])
    end
    
    return @sinonimos.all
  end
end
