class Ejemplar < ActiveRecord::Base
  
  set_table_name "ejemplares"
  
  default_scope :order => 'nombre',
    :include => :taxon
  
  
  belongs_to :usuario
  
  belongs_to :coleccion
  
  belongs_to :muestra
  
  delegate :muestreo, :sitio,
    :to => :muestra, 
    :allow_nil => true
  
  belongs_to :taxon
  
  
  validates_presence_of :usuario_id, :coleccion_id, :muestra_id, :taxon_id, :numero_coleccion, :nombre
  
  validates_numericality_of :machos, :hembras, :inmaduros, :indeterminados, :numero_coleccion,
    :only_integer => true,
    :greater_than_or_equal_to => 0
    
  validates_numericality_of :total, 
    :only_integer => true,
    :greater_than => 0
    
  validates_uniqueness_of :nombre,
    :message => "Nro. de Coleccion no esta disponible.",
    :if => Proc.new {|ejemplar| ejemplar.read_attribute(:numero_coleccion) != 0}
  
  validates_uniqueness_of :taxon_id,
    :scope => :muestra_id,
    :message => "previamente agregado, agrege uno distinto o vuelva a la muestra actualize el ya existente"
  
  
  attr_readonly :usuario_id
  
  before_validation :calcular_total
  
  before_validation :nombrar
  
  before_validation :sin_numero_coleccion

  attr_writer :muestreo_id, :sitio_id

  def numero_coleccion
    read_attribute(:numero_coleccion).to_s.rjust(3,'0')
  end
  
  private
  
  def sin_numero_coleccion
    unless read_attribute(:numero_coleccion)
      write_attribute(:numero_coleccion, 0)
    end
  end
  
  def calcular_total
    self.total = self.machos + self.hembras + self.inmaduros + self.indeterminados
  end
  
  def nombrar
    self.nombre = "#{coleccion.numero}-#{numero_coleccion}#{subindice.upcase}"
  end
  
  def muestre_id
    muestreo ? muestreo.id : nil
  end

  def sitio_id
    sitio ? sitio.id : nil
  end

end
