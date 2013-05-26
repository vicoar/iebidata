class Coleccion < ActiveRecord::Base
  
  set_table_name "colecciones"
  
  
  default_scope :order => 'numero'
  
  
  belongs_to :usuario,
    :validate => true
  
  has_many :ejemplares,
    :class_name => "Ejemplar"
  
  
  validates_presence_of :usuario_id, :nombre, :numero
  
  validates_uniqueness_of :nombre, :numero,
    :case_sensitive => false
  
  validates_numericality_of :numero,
    :greater_than => 0,
    :only_integer => true
  
  attr_readonly :usuario_id
  
  before_save :renombrar_ejemplares
  
  before_destroy :sin_ejemplares
  
  def numero
    read_attribute(:numero).to_s.rjust(3,'0')
  end
  
  def numero_y_nombre
    "#{numero} - #{nombre}"
  end
  
  def renombrar_ejemplares
    if numero_changed?
      ejemplares.update_all "nombre = CONCAT(lpad(#{numero},3,0), '-', lpad(ejemplares.numero_coleccion,3,0) )"
    end
  end
  
  def sin_ejemplares
    if ejemplares.count > 0
      errors.add_to_base "No se puede eliminar esta coleccion porque contiene #{ejemplares.count} ejemplares"
      return false
    end
  end
  
  
end
