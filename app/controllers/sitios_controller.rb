class SitiosController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :sitio_sweeper, :only => [:create, :update, :destroy]
  
  # GET /sitios
  # GET /sitios.xml
  def index
    @sitios = Sitio.includes(:muestreo).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sitios }
    end
  end

  # GET /sitios/1
  # GET /sitios/1.xml
  def show
    @sitio = Sitio.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sitio }
    end
  end

  # GET /sitios/new
  # GET /sitios/new.xml
  def new
    @muestreo = Muestreo.find params[:muestreo_id]
    @sitio = @muestreo.sitios.build
    if @muestreo.sitios.count > 0
      @sitio.latitud = @muestreo.sitios.average('latitud')
      @sitio.longitud = @muestreo.sitios.average('longitud')
    else
      @sitio.latitud = 0
      @sitio.longitud = 0
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sitio }
    end
  end

  # GET /sitios/1/edit
  def edit
    @sitio = Sitio.find(params[:id])
  end

  # POST /sitios
  # POST /sitios.xml
  def create
    @sitio = Sitio.new(params[:sitio])
    @sitio.usuario = current_user

    respond_to do |format|
      if @sitio.save
        format.html { redirect_to(@sitio, :notice => "Sitio <b>#{@sitio.nombre}</b> creado exitosamente.") }
        format.xml  { render :xml => @sitio, :status => :created, :location => @sitio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sitio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sitios/1
  # PUT /sitios/1.xml
  def update
    @sitio = Sitio.find(params[:id])

    respond_to do |format|
      if @sitio.update_attributes(params[:sitio])
        format.html { redirect_to(@sitio, :notice => "Sitio <b>#{@sitio.nombre}</b> actualizado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sitio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sitios/1
  # DELETE /sitios/1.xml
  def destroy
    @sitio = Sitio.find(params[:id])
    
    respond_to do |format|
      if @sitio.destroy
        format.html { redirect_to(@sitio.muestreo, :notice => "Sitio <b>#{@sitio.nombre}</b> eliminado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@sitio, :alert => @sitio.errors.full_messages) }
        format.xml  { head :ok }
      end      
    end
  end
  
  def select_muestra
    @sitio = Sitio.find(params[:id])
    @muestras = @sitio.muestras
    
    render :inline => "<%= collection_select :ejemplar, :muestra_id, @muestras, :id, :nombre %>"
  end
  
end
