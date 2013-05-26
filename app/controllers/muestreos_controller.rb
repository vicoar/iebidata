class MuestreosController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :muestreo_sweeper, :only => [:create, :update, :destroy]
  # GET /muestreos
  # GET /muestreos.xml
  def index
    @muestreos = Muestreo.page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @muestreos }
    end
  end

  # GET /muestreos/1
  # GET /muestreos/1.xml
  def show
    @muestreo = Muestreo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @muestreo }
    end
  end

  # GET /muestreos/new
  # GET /muestreos/new.xml
  def new
    @muestreo = Muestreo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @muestreo }
    end
  end

  # GET /muestreos/1/edit
  def edit
    @muestreo = Muestreo.find(params[:id])
  end

  # POST /muestreos
  # POST /muestreos.xml
  def create
    @muestreo = Muestreo.new(params[:muestreo])
    @muestreo.usuario = current_user

    respond_to do |format|
      if @muestreo.save
        format.html { redirect_to(@muestreo, :notice => "Muestreo <b>#{@muestreo.nombre}</b> creado exitosamente.") }
        format.xml  { render :xml => @muestreo, :status => :created, :location => @muestreo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @muestreo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /muestreos/1
  # PUT /muestreos/1.xml
  def update
    @muestreo = Muestreo.find(params[:id])

    respond_to do |format|
      if @muestreo.update_attributes(params[:muestreo])
        format.html { redirect_to(@muestreo, :notice => "Muestreo <b>#{@muestreo.nombre}</b> actualizado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @muestreo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /muestreos/1
  # DELETE /muestreos/1.xml
  def destroy
    @muestreo = Muestreo.find(params[:id])
    
    respond_to do |format|
      if @muestreo.destroy
        format.html { redirect_to(muestreos_url, :notice => "Muestreo <b>#{@muestreo.nombre}</b> eliminado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@muestreo, :alert => @muestreo.errors.full_messages) }
        format.xml  { head :ok }
      end      
    end
  end
  
  def select_sitio
    @muestreo = Muestreo.find(params[:id])
    @sitios = @muestreo.sitios
    
    render :inline => "<%= collection_select :ejemplar, :sitio_id, @sitios, :id, :nombre %>"
  end

=begin
  def resumen
    @muestreo = Muestreo.find(params[:id])
    @taxon    = Taxon.find(params[:taxon])
    @muestras = @muestreo.muestras.find(:all, 
      :joins => "INNER JOIN ejemplares ON muestras.id = ejemplares.muestra_id AND ejemplares.taxon_id = #{@taxon.id}",
      :order => "nombre")
    
    if request.xhr?
      render :action => "resumen", :layout => false
    else
      redirect_to @muestreo
    end
  end
=end

end
