class CategoriasController < ApplicationController
  
  filter_access_to :all
  
  #caches_action :index, :show
  cache_sweeper :categoria_sweeper, :only => [:create, :update, :destroy]
  
  # GET /categorias
  # GET /categorias.xml
  def index
    @categorias = Categoria.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categorias }
    end
  end

  # GET /categorias/1
  # GET /categorias/1.xml
  def show
    @categoria = Categoria.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @categoria }
    end
  end

  # GET /categorias/new
  # GET /categorias/new.xml
  def new
    max = Categoria.maximum('nivel')
    max = max ? max + 1 : 0
    @categoria = Categoria.new(:nivel => max, :subnivel => 0)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @categoria }
    end
  end

  # GET /categorias/1/edit
  def edit
    @categoria = Categoria.find(params[:id])
  end

  # POST /categorias
  # POST /categorias.xml
  def create
    @categoria = Categoria.new(params[:categoria])
    @categoria.usuario = current_user
    
    # evito que 2 categorias tengan el mismo nivel
   # cant = Categoria.count
    #if @categoria.nivel && @categoria.nivel < cant
      #si el nivel esta definido y es un valor dentro de los ya registrados entonces muevo uno mas todos los niveles superiores para darle cabida
    #  Categoria.update_all("nivel = nivel + 1", ["nivel >= ?", @categoria.nivel])
    #else
      #si no estuviera definido o su valor sea superior a todos los de tabla (ej 25055) entonces le asigno su lugar correspondiente
    #  @categoria.nivel = cant
    #end
    

    respond_to do |format|
      if @categoria.save
        format.html { redirect_to(@categoria, :notice => "Categoria <b>#{@categoria.nombre}</b> creada exitosamente.") }
        format.xml  { render :xml => @categoria, :status => :created, :location => @categoria }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @categoria.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categorias/1
  # PUT /categorias/1.xml
  def update
    @categoria = Categoria.find(params[:id])

    respond_to do |format|
      if @categoria.update_attributes(params[:categoria])
        format.html { redirect_to(@categoria, :notice => "Categoria <b>#{@categoria.nombre}</b> actualizada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @categoria.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categorias/1
  # DELETE /categorias/1.xml
  def destroy
    @categoria = Categoria.find(params[:id])
    
    respond_to do |format|
      if @categoria.destroy
        format.html { redirect_to(categorias_url, :notice => "Categoria <b>#{@categoria.nombre}</b> eliminada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@categoria, :alert => @categoria.errors.full_messages) }
        format.xml  { render :xml => @categoria.errors, :status => :unprocessable_entity }
      end      
    end
  end
  
  #AUTOCOMPLETAR
  def autocompletar_taxon
    @cadena = params[:cadena]
    if params[:categoria_id].to_i == 0
      @taxones = Taxon
    else
      @categoria = Categoria.find(params[:categoria])
      @taxones = @categoria.taxones
    end
    @taxones = @taxones.select('id, nombre').where(["nombre like ?", "%#{@cadena}%"]).limit(10)
    respond_to do |format|
      format.json #autocompletar.json.erb
    end
  end
  
end
