class Pais < ActiveRecord::Base
  
  set_table_name "paises"
  
  default_scope :order => 'nombre'
  
  
  has_many :regiones,
    :class_name => "Region"
    
  has_many :sitios,
    :through => :regiones
  
  validates_presence_of :nombre, :nombre_ingles, :continente
  
  validates_uniqueness_of :nombre, :nombre_ingles,
    :case_sensitive => false
  
 
  before_destroy :sin_regiones
  
  def sin_regiones
    if regiones.count > 0
      errors.add_to_base "No se puede eliminar este pais porque contiene #{regiones.count} regiones"
      return false
    end
  end
  
end
