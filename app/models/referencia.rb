class Referencia < ActiveRecord::Base
  
  default_scope :order => "titulo"
  
  
  belongs_to :taxon
  
  belongs_to :usuario
  
  
  validates_presence_of :usuario_id, :taxon_id, :autor, :titulo
  
  validates_uniqueness_of :titulo,
    :scope => [:autor, :taxon_id]
  
  has_attached_file :archivo, 
    :url  => "/uploads/referencias/:id/:basename.:extension",
    :path => ":rails_root/public/uploads/referencias/:id/:basename.:extension"
  
  attr_readonly :usuario_id
  
  
  def nombre
    "#{autor} - #{titulo}"
  end
end
