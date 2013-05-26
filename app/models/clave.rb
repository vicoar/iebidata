class Clave < ActiveRecord::Base
  
  acts_as_nested_set :order => "respuesta",
    :dependent => :destroy
  
  has_one :imagen,
    :as => :album,
    :dependent => :destroy
  
  belongs_to :usuario
  
  belongs_to :taxon
  
  
  validates_presence_of :usuario_id, :dilema
   
  validates_uniqueness_of :dilema,
    :scope => :parent_id,
    :case_sensitive => false  
  
  validates_associated :children
  
  validate :sin_taxon_si_tiene_hijos
  
  attr_readonly :usuario_id
  
  after_update :save_children
  
  def eliminar
    if children.count > 0
      errors.add_to_base "No se puede eliminar esta clave porque contiene #{children.count} subclaves"
      return false
    else
      destroy
    end  
  end
  
  def sin_taxon_si_tiene_hijos
    if taxon_id && children.count > 0 
      errors.add "taxon_id", "no puede estar presente si tiene opciones agregadas"
    end
  end
  
  def new_child_attributes=(child_attributes)
    child_attributes.each do |attributes|
      attributes[:usuario_id] = usuario_id
      children.build(attributes)
    end
  end
  
  def existing_child_attributes=(child_attributes)
    children.reject(&:new_record?).each do |child|
      attributes = child_attributes[child.id.to_s]
      if attributes
        child.attributes = attributes
      else
        child.delete(child)
      end
    end
  end
  
  def save_children
    children.each do |child|
      child.save(false)
    end
  end
  
  def final?
    taxon_id || taxon_nombre.to_s != ""
  end
  
end
