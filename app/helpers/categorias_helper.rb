module CategoriasHelper
  
  def nivel_sel
    vector = Array.new
    max = Categoria.maximum('nivel')
    max = max ? max + 1 : 0
    (0..max).each do |i|
      vector << [i,i]
    end
    return vector
  end
  
  def subnivel_sel
    vector = Array.new
    min = Categoria.minimum('subnivel')
    min = min ? min - 1 : 0
    max = Categoria.maximum('subnivel')
    max = max ? max + 1 : 0
    (min..max).each  do |i|
      vector << [i,i]
    end
    return vector
  end
  
end
