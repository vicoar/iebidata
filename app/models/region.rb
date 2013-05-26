class Region < ActiveRecord::Base
  
  set_table_name "regiones"
  
  default_scope :order => 'nombre',
    :include => :pais
  
  belongs_to :pais
    
  has_many :sitios
  
  
  validates_presence_of :pais_id, :nombre
  
  validates_uniqueness_of :nombre,
    :scope => :pais_id,
    :case_sensitive => false
  
  
  before_destroy :sin_ciudades
  
  def sin_ciudades
    if ciudades.count > 0 || muestras.count > 0
      errors.add_to_base "No se puede eliminar esta region porque contiene #{ciudades.count} ciudades y #{muestras.count} muestras"
      return false
    end
  end
  
end
