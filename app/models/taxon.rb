class Taxon < ActiveRecord::Base
  
  set_table_name "taxones"
  
  acts_as_nested_set :order => "nombre", 
    :dependent => :destroy
    
  
  belongs_to :categoria
  
  belongs_to :usuario
  
  belongs_to :coleccion
  
  has_many :subcategorias,
    :through => :children,
    :source  => :categoria,
    :uniq => true
  
  has_many :sinonimos,
    :dependent => :delete_all 
    
  has_many :referencias,
    :dependent => :delete_all
    
  has_many :ejemplares,
    :class_name => "Ejemplar"
    
  has_many :muestras,
    :through => :ejemplares,
    :uniq => true    
  
  has_many :imagenes,
    :class_name => "Imagen",
    :as => :album,
    :dependent => :destroy
  
  has_many :claves,
    :class_name => "Clave",
    :dependent => :nullify
  
  
  validates_presence_of :usuario_id, :categoria_id, :nombre
  
  validates_presence_of :coleccion_id, :numero_especie,
    :if => Proc.new { |taxon| taxon.categoria.final? },
    :message => 'no puede estar vacio si es un Morfo/Especie'
  
  validates_uniqueness_of :numero_especie,
    :case_sensitive => :coleccion_id,
    :if => Proc.new { |taxon| taxon.categoria.final? }
  
  validates_uniqueness_of :nombre,
    :case_sensitive => false
    
  before_save :eliminar_coleccion_para_no_especie
  
  attr_readonly :usuario_id
  
  attr_accessor :aplicar_visibilidad_a_hijos_y_padres
  
  scope :ordenados, order(:nombre)
  
  scope :finales, where(:categoria_id => Categoria.final).ordenados
   
  def sitios
    Sitio.select("DISTINCT sitios.*").joins("INNER JOIN ejemplares ON (ejemplares.taxon_id = #{id}) " +
      "INNER JOIN muestras ON (muestras.id = ejemplares.muestra_id)").where("sitios.id = muestras.sitio_id")
  end
  
  def muestreos
    Muestreo.select("DISTINCT muestreos.*").joins("INNER JOIN ejemplares ON (ejemplares.taxon_id = #{id}) " +
      "INNER JOIN muestras ON (muestras.id = ejemplares.muestra_id) " +
      "INNER JOIN sitios ON (sitios.id = muestras.sitio_id)").where("muestreos.id = sitios.muestreo_id")
  end
 
  def eliminar
     if children.count > 0 || ejemplares.count > 0
       errors.add_to_base "No se puede eliminar este taxon porque contiene #{children.count} taxones y #{ejemplares.count} ejemplares."
       return false
     else
       destroy
     end  
  end
  
  def hijos(categoria)
    if categoria.final?
      hijos = Taxon.where("lft > ? AND rgt < ?", lft, rgt)
    else
      hijos = Taxon.where(:parent_id => id)
    end
    hijos = hijos.ordenados.where(:categoria_id => categoria.id)
  end
  
  def eliminar_coleccion_para_no_especie
    if coleccion && !categoria.final?
      self.coleccion_id = nil
      self.numero_especie = nil
    end
  end
  
  #def subcategorias
  #	Categoria.where("id IN (SELECT DISTINCT categoria_id FROM taxones WHERE parent_id = ?)", id)
  #end
    
end
