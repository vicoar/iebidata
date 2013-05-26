class Sinonimo < ActiveRecord::Base
  
  default_scope :order => 'nombre'
  
  
  belongs_to :usuario
  
  belongs_to :taxon
  
  
  validates_presence_of :usuario_id, :taxon_id, :nombre
  
  validates_uniqueness_of :nombre,
    :scope => :taxon_id,
    :case_sensitive => false
  
  attr_readonly :usuario_id
  
end
