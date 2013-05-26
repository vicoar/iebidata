class Sitio < ActiveRecord::Base
  
  default_scope :order => 'nombre'
  
  acts_as_gmappable :address => nil,
    :process_geocoding => false,
    :validation => false,
    :lat => "latitud", :lng => "longitud",
    :language => "es"
  
  belongs_to :muestreo
  
  belongs_to :usuario
  
  belongs_to :region
  
  delegate :pais,
    :to => :region
  
  has_many :muestras
  
  has_many :ejemplares,
    :through => :muestras
    
  validates_presence_of :usuario_id, :muestreo_id, :nombre, :fecha, :longitud, :latitud, :ubicacion, :region_nombre, :pais_nombre
  
  validates_numericality_of :longitud, :latitud
  
  validates_uniqueness_of :nombre,
    :scope => :muestreo_id,
    :case_sensitive => false

  attr_writer :latitud_grados, :latitud_minutos, :latitud_segundos,
    :longitud_grados, :longitud_minutos, :longitud_segundos

  attr_writer :region_nombre, :pais_nombre
  
  validates_numericality_of :latitud_grados,
    :only_integer => true,
    :greater_than_or_equal_to => -90,
    :less_than_or_equal_to => 90
  
  validates_numericality_of :longitud_grados,
    :only_integer => true,
    :greater_than_or_equal_to => -180,
    :less_than_or_equal_to => 180
    
  validates_numericality_of :latitud_minutos, :longitud_minutos,
    :only_integer => true,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 60
  
  validates_numericality_of :latitud_segundos, :longitud_segundos,
    :only_integer => false,
    :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => 60
  
  before_save :guardar_region_y_pais
  
  before_save :latlng_a_flot
  
  before_destroy :sin_muestras
  
  def latitud_grados
    to_dms(latitud, :degrees)
  end

  def latitud_minutos
    to_dms(latitud, :minutes)
  end

  def latitud_segundos
    to_dms(latitud, :seconds)
  end

  def longitud_grados
    to_dms(longitud, :degrees)
  end

  def longitud_minutos
    to_dms(longitud, :minutes)
  end

  def longitud_segundos
    to_dms(longitud, :seconds)
  end

  def region_nombre
    region.nombre if region
  end

  def pais_nombre
    region.pais.nombre if region
  end
  
  def sin_muestras
    if muestras.count > 0
      errors.add_to_base "No se puede eliminar este sitio porque contiene #{muestras.count} muestras"
      return false
    end
  end
  
  def gmaps4rails_address
    
  end
  
  def gmaps4rails_infowindow
    salida = "<div class='infowindow'>"
    salida += "<p><b>Nombre:</b> #{nombre}</p>" if nombre
    salida += "<p><b>Ecoregion:</b> #{ecoregion}</p>" if ecoregion
    salida += "<p><b>Muestreo:</b> #{muestreo.nombre}</p>" if muestreo
    salida += "<p><b>Ubicacion:</b> #{ubicacion}</p>" if ubicacion
    salida += "</div>"
    salida
  end
  
  def gmaps4rails_title
    "#{muestreo.nombre} > #{nombre}"
  end
  
  
  def guardar_region_y_pais
    pais = Pais.where(:nombre => pais_nombre).first
    unless pais
      pais = Pais.create(:nombre => pais_nombre)
    end
    
    region = pais.regiones.where(:nombre => region_nombre).first
    unless region
      region = pais.regiones.create(:nombre => region_nombre)
    end
    self.region_id = region.id
  end
  
  def latlng_a_flot
    self.latitud = to_float(latitud_grados, latitud_minutos, latitud_segundos)
    self.longitud = to_float(longitud_grados, longitud_minutos, longitud_segundos)
  end
  
  private
  
  def to_dms(degreesTemp, dmg = :seconds)
    #extraido de http://zonalandeducation.com/mmts/trigonometryRealms/degMinSec/degMinSec.htm
    isNegativeAngle = false
    if degreesTemp < 0
        isNegativeAngle = true
        degreesTemp = -degreesTemp
    end
    
    degrees     = degreesTemp.floor
    if dmg == :degrees
      if isNegativeAngle
        return -degrees
      else
        return degrees
      end 
    end

    minutesTemp = degreesTemp - degrees
    minutesTemp = 60.0 * minutesTemp
    minutes     = minutesTemp.floor
    if dmg == :minutes
      return minutes
    end

    secondsTemp = minutesTemp - minutes
    secondsTemp = 60.0 * secondsTemp
    seconds     = (secondsTemp * 100.0).round / 100.0
    return seconds
  end
  
  def to_float(d, m, s)
    degree = d.to_f
    minutes = m.to_f
    seconds = s.to_f
    
    isNegativeAngle = false
    if degree < 0
      isNegativeAngle = true
      degree = -degree
    end
    
    result = degree + minutes / 60.0 + seconds / 3600.0
    
    if isNegativeAngle
      return -result
    else
      return result
    end
  end
  
end
