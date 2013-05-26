class ColeccionesController < ApplicationController
  
  filter_access_to :all
  
  #caches_action :index, :show
  #cache_sweeper :coleccion_sweeper, :only => [:create, :update, :destroy]
  
  # GET /colecciones
  # GET /colecciones.xml
  def index
    @colecciones = Coleccion.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @colecciones }
    end
  end

  # GET /colecciones/1
  # GET /colecciones/1.xml
  def show
    @coleccion = Coleccion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coleccion }
    end
  end

  # GET /colecciones/new
  # GET /colecciones/new.xml
  def new
    @coleccion = Coleccion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coleccion }
    end
  end

  # GET /colecciones/1/edit
  def edit
    @coleccion = Coleccion.find(params[:id])
  end

  # POST /colecciones
  # POST /colecciones.xml
  def create
    @coleccion = Coleccion.new(params[:coleccion])
    @coleccion.usuario = current_user

    respond_to do |format|
      if @coleccion.save
        format.html { redirect_to(@coleccion, :notice => "Coleccion <b>#{@coleccion.nombre}</b> creada exitosamente.") }
        format.xml  { render :xml => @coleccion, :status => :created, :location => @coleccion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coleccion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /colecciones/1
  # PUT /colecciones/1.xml
  def update
    @coleccion = Coleccion.find(params[:id])

    respond_to do |format|
      if @coleccion.update_attributes(params[:coleccion])
        format.html { redirect_to(@coleccion, :notice => "Coleccion <b>#{@coleccion.nombre}</b> actualizada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coleccion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /colecciones/1
  # DELETE /colecciones/1.xml
  def destroy
    @coleccion = Coleccion.find(params[:id])
    
    respond_to do |format|
      if @coleccion.destroy
        format.html { redirect_to(colecciones_url, :notice => "Coleccion <b>#{@coleccion.nombre}</b> eliminada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@coleccion, :alert => @coleccion.errors.full_messages) }
        format.xml  { render :xml => @categoria.errors, :status => :unprocessable_entity }
      end      
    end
  end
  
  
end
