class Invitacion < ActiveRecord::Base
  
  default_scope :order => "nombre"
  
  scope :solicitadas, where(:remitente_id => nil)
  
  belongs_to :remitente,
    :class_name => 'Usuario'
  
  has_one :destinatario,
    :class_name => 'Usuario'
    
  validates_presence_of :nombre, 
    :unless => Proc.new { |invitacion| invitacion.remitente }
  
  validates_format_of :destinatario_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validate :destinatario_no_registrado
    
  before_create :generar_pase
  
  before_destroy :sin_usuario
  
  def enviar
    Mailer.invitacion(self).deliver
    update_attribute(:enviado, Time.now)
  end

  private

  def destinatario_no_registrado
    errors.add :destinatario_email, 'ya esta registrado' if Usuario.where(:email => destinatario_email).count > 0
  end

  def generar_pase
    self.pase = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
    
  def sin_usuario
    if destinatario
      errors.add_to_base "No se puede eliminar esta invitacion porque el usuario #{destinatario.nombre} ya la uso"
      return false
    end
  end
  
end
