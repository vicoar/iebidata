class Categoria < ActiveRecord::Base
  
  default_scope :order => 'nivel, subnivel'
  
  
  validates_presence_of :usuario_id, :nombre
  
  validates_uniqueness_of :nombre,
    :case_sensitive => false
  
  validates_numericality_of :nivel, :subnivel,
    :only_integer => true
  
  attr_readonly :usuario_id
  
  after_save :marcar_final
  
  after_destroy :marcar_final
  
  before_destroy :sin_taxones
  
  
  def self.raices
    Categoria.find(:all, :conditions => ["nivel = 0 and subnivel <= 0"])
  end
  
  def subcategorias
    #Se pregunta por cada consulta para no agregar NILs a la salida
    
    salida = Array.new
    
    return salida if final #Si la categoria es final no puede tener hijos
    
    subcat = Categoria.find(:first, :conditions => ["nivel = ? and subnivel > ?", self.nivel, self.subnivel])
    if subcat
      salida << subcat
    end 
    
    if self.subnivel > 0
      supercategorias = Categoria.find(:all, :conditions => ["nivel = ? + 1 and subnivel <= 0", self.nivel])
      if supercategorias
        salida = salida + supercategorias
      end
    end
    
    if self.subnivel == 0
      obligatoria = Categoria.find(:all, :conditions => ["nivel = ? + 1 and subnivel = 0", self.nivel])
      if obligatoria
        salida = salida + obligatoria
      end
    end
    
    #Agregar los que pueden tener muestras
    salida = salida + Categoria.find(:all, :conditions => ["muestras = 1 and ( nivel >= ? and subnivel > ? or nivel > ? )", nivel, subnivel, nivel])
    
    return salida.uniq
  end
  
  def inferiores
    Categoria.find(:all, :conditions => ["nivel >= ? and subnivel > ? or nivel > ?", nivel, subnivel, nivel])
  end
  
  def siguiente
    Categoria.find(:first, :conditions => ["nivel >= ? and subnivel > ? or nivel > ?", nivel, subnivel, nivel])
  end
  
  def marcar_final
    Categoria.update_all "final = 0"
    last = Categoria.last
    Categoria.update_all "final = 1", "id = #{last.id}"
  end
  
  def self.final
    find(:first, :conditions => {:final => true})
  end
  
  def sin_taxones
    if taxones.count > 0
      errors.add_to_base "No se puede eliminar esta categoria porque esta asociada a #{taxones.count} taxones"
      return false
    end
  end
  
end
