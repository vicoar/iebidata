class Muestreo < ActiveRecord::Base
  
  default_scope :order => 'nombre'
  
  
  belongs_to :usuario
  
  has_many :sitios
  
  has_many :muestras,
    :through => :sitios  
  
  validates_presence_of :usuario_id, :nombre, :fecha
  
  validates_uniqueness_of :nombre,
    :case_sensitive => false
  
  
  attr_readonly :usuario_id
  
  
  before_destroy :sin_sitios
  
  
  def sin_sitios
    if sitios.count > 0
      errors.add_to_base "No se puede eliminar este muestreo porque contiene #{sitios.count} sitios"
      return false
    end
  end
  
  def ejemplares
    Ejemplar.joins("INNER JOIN sitios ON (sitios.muestreo_id = #{id}) "+
      "INNER JOIN muestras ON (muestras.sitio_id = sitios.id) AND muestras.id = ejemplares.id")
  end
  
  def taxones
    Taxon.select("DISTINCT taxones.*").joins("INNER JOIN sitios ON (sitios.muestreo_id = #{id}) "+
      "INNER JOIN muestras ON (muestras.sitio_id = sitios.id) " +
      "INNER JOIN ejemplares ON (ejemplares.muestra_id = muestras.id) AND taxones.id = ejemplares.taxon_id")
  end
  
end
