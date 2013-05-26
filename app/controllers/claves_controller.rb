class ClavesController < ApplicationController
  
  filter_access_to :all
  
  #caches_action :index, :show
  #cache_sweeper :clave_sweeper, :only => [:create, :update, :destroy]
    
  # GET /claves
  # GET /claves.xml
  def index
    @claves = Clave.roots

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @claves }
    end
  end

  # GET /claves/1
  # GET /claves/1.xml
  def show
    @clave = Clave.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @clave }
    end
  end

  # GET /claves/new
  # GET /claves/new.xml
  def new
    if params[:super]
      superclave = Clave.find params[:super]
      @clave = superclave.children.new
    else
      @clave = Clave.new
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @clave }
    end
  end

  # GET /claves/1/edit
  def edit
    @clave = Clave.find(params[:id])
  end

  # POST /claves
  # POST /claves.xml
  def create
    @clave = Clave.new(params[:clave])
    @clave.usuario = current_user

    respond_to do |format|
      if @clave.save
        format.html { redirect_to(clave_path(@clave), :notice => 'Clave creada exitosamente.') }
        format.xml  { render :xml => @clave, :status => :created, :location => @clave }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @clave.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /claves/1
  # PUT /claves/1.xml
  def update
    @clave = Clave.find(params[:id])

    respond_to do |format|
      if @clave.update_attributes(params[:clave])
        format.html { redirect_to(clave_path(@clave), :notice => 'Clave actualizada exitosamente.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @clave.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /claves/1
  # DELETE /claves/1.xml
  def destroy
    @clave = Clave.find(params[:id])
   
    respond_to do |format|
      if @clave.eliminar
        format.html { redirect_to(@clave.parent ? clave_path(@clave.parent) : claves_path, :notice => 'Clave eliminada exitosamente.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(clave_path(@clave), :alert => @clave.errors.full_messages) }
        format.xml  { render :xml => @clave.errors, :status => :unprocessable_entity }
      end      
    end
  end
  
  # GET /opciones/1
  def opciones
    @clave = Clave.find(params[:id])
    if @clave.children.count < 2
      2.times { @clave.children.build }
    end
  end
  
  # GET /cambiar/1
  def cambiar
    params[:clave][:existing_child_attributes] ||= {}
    
    @clave = Clave.find(params[:id])
    if @clave.update_attributes(params[:clave])
      flash[:notice] = "Opciones modificadas exitosamente."
      redirect_to clave_path(@clave)
    else
      render :action => 'opciones'
    end
  end
  
  def seleccionar_imagen
    @clave = Clave.find(params[:id])
    @taxones = Taxon.finales
    if params[:taxon_id]
      @taxon = Taxon.find params[:taxon_id]
    else
      @taxon = @taxones.first
    end
  end
  
  def asignar_imagen
    @clave = Clave.find(params[:id])
    if params[:imagen_id]
      imagen_vieja = Imagen.find params[:imagen_id]
      imagen_nueva = @clave.build_imagen
      imagen_nueva.imagen = imagen_vieja.imagen
      imagen_nueva.usuario = current_user
      if imagen_nueva.save
        flash[:notice] = "Imagen asociada correctamente."
      end
    end
    redirect_to @clave
  end
  
end
