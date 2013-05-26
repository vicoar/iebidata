class Usuario < ActiveRecord::Base
  
  default_scope :order => 'nombre'
  
  acts_as_authentic
  
  has_many :invitaciones_enviadas,
    :class_name => 'Invitacion',
    :foreign_key => 'remitente_id'
  
  belongs_to :invitacion    
    
  has_many :categorias
  
  has_many :claves,
    :class_name => "Clave"
  
  has_many :colecciones,
    :class_name => "Coleccion"
  
  has_many :ejemplares,
    :class_name => "Ejemplar"
  
  has_many :imagenes,
    :class_name => "Imagen"
  
  has_many :muestras
  
  has_many :muestras_identificadas,
  	:class_name => "Muestra",
  	:foreign_key => :identificador_id
  
  has_many :muestras_colectadas,
  	:class_name => "Muestra",
  	:foreign_key => :colector_id
  
  has_many :muestreos
  
  has_many :referencias
  
  has_many :sinonimos
  
  has_many :sitios
  
  has_many :taxones,
    :class_name => "Taxon"
  
  has_many :busquedas,
    :dependent => :delete_all
    
  validates_presence_of :nombre, :tipo
  
  validates_length_of :nombre,
    :minimum => 6
  
  validates_presence_of :invitacion_id,
    :message => 'es necesaria'
  
  validates_uniqueness_of :invitacion_id
  
  
  #remember_me_for 1.months
  
  before_validation :agregar_tipo
  
  before_destroy :sin_nada
  
  ROLES = %w[ administrador autor registrado ]
  
  scope :editores, where("tipo != ?", ROLES[2])
  
  attr_readonly :invitacion_id
  
  def role_symbols
    [tipo.to_sym]
  end
  
  def tipo?(rol)
    rol.to_s == tipo
  end
  
  def invitacion_pase
    invitacion.pase if invitacion
  end
  
  def invitacion_pase=(pase)
    self.invitacion = Invitacion.find(:first, :conditions => { :pase => pase })
  end
  
  def enviar_instrucciones_recuperar_cuenta
    reset_perishable_token!
    Mailer.instrucciones_recuperar_cuenta(self).deliver
  end
  
  private
  
  def agregar_tipo
    self.tipo = ROLES.last unless tipo
  end
  
  def sin_nada
    if ( categorias.count > 0 || claves.count > 0 || colecciones.count > 0 || ejemplares.count > 0 || 
      imagenes.count > 0 || muestras.count >0 || muestras_identificadas.count > 0 || muestras_colectadas.count > 0 ||
      muestreos.count > 0 || referencias.count > 0 || sinonimos.count > 0 || taxones.count > 0 )
      errors.add_to_base "No se puede eliminar este taxon porque contiene #{categorias.count} categorias, #{claves.count} claves, #{colecciones.count} colecciones, " +
        "#{ejemplares.count} ejemplares, #{imagenes.count} imagenes, #{muestras.count} muestras, #{muestreos.count} muestreos, #{referencias.count} referencias, " +
        "#{sinonimos.count} sinonimos y #{taxones.count} taxones."
      return false
    end
  end  
  
end
