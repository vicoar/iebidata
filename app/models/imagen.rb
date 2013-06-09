require 'paperclip_processors/watermark'

class Imagen < ActiveRecord::Base
  
  set_table_name "imagenes"
  
  default_scope :order => 'posicion'
  
  belongs_to :album, 
    :polymorphic => true
  
  delegate :taxon,
    :to => :album
  
  belongs_to :usuario
    
  has_attached_file :imagen, 
    :processors => [:thumbnail, :watermark],
    :styles => {
      :min => "150x150#", 
      :med => {
        :geometry => '640x480>',
        :watermark_path => "#{Rails.root}/config/logo.png",
        :position => 'Center'
      }, 
      :max => "1024x768>", 
      :clave => "400x400#" }
  
  delegate :url, :to => :imagen
  
   
  validates_attachment_presence :imagen
  
  validates_presence_of :usuario_id, :album_id, :album_type, :posicion
  
  attr_readonly :usuario_id  
  
  
  before_validation :agregar_posicion
  
  
  def agregar_posicion
    unless posicion
      max = Imagen.maximum('id')
      self.posicion = max ? max + 1 : 1
    end
  end
      
end
