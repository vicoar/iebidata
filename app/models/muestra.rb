class Muestra < ActiveRecord::Base
  
  default_scope :order => 'nombre'
  
  
  belongs_to :usuario
  
  belongs_to :sitio
  
  delegate :muestreo,
    :to => :sitio
  
  has_many :ejemplares,
    :class_name => "Ejemplar",
    :order => "nombre"
  
  has_many :taxones,
    :through => :ejemplares,
    :uniq => true
  
  belongs_to :colector,
  	:class_name => 'Usuario'
  	
  belongs_to :identificador,
  	:class_name => 'Usuario'
  
  
  validates_presence_of :usuario_id, :nombre, :colector_id, :identificador_id
  
  validates_uniqueness_of :nombre
    
  
  attr_readonly :usuario_id
  
  
  before_destroy :sin_ejemplares
    
  def sin_ejemplares
    if ejemplares.count > 0
      errors.add_to_base "No se puede eliminar esta muestra porque contiene #{ejemplares.count} ejemplares"
      return false
    end
  end
  
end
