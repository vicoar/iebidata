class ImagenesController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :imagen_sweeper, :only => [:create, :update, :destroy, :ajax_upload, :ordenar]
  
  # GET /imagenes
  # GET /imagenes.xml
  def index
    if params[:taxon_id]
      taxon = Taxon.find params[:taxon_id]
      @imagenes = taxon.imagenes.page(params[:page])
    end
    
    if params[:clave_id]
      clave = Clave.find params[:clave_id]
      @imagenes = clave.imagen.page(params[:page])
    end
    
    unless @imagenes
      @imagenes = Imagen.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @imagens }
    end
  end

  # GET /imagenes/1
  # GET /imagenes/1.xml
  def show
    @imagen = Imagen.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @imagen }
    end
  end

  # GET /imagenes/new
  # GET /imagenes/new.xml
  def new
    if params[:taxon_id]
      @taxon = Taxon.find params[:taxon_id]
      @imagen = @taxon.imagenes.new
    else
      @clave = Clave.find params[:clave_id]
      @imagen = @clave.build_imagen
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @imagen }
    end
  end

  # GET /imagenes/1/edit
  def edit
    @imagen = Imagen.find(params[:id])
  end

  # POST /imagenes
  # POST /imagenes.xml
  def create
    @imagen = Imagen.new(params[:imagen])
    @imagen.usuario = current_user
    
    respond_to do |format|
      if @imagen.save
        format.html { redirect_to(@imagen, :notice => 'Imagen creada exitosamente.') }
        format.xml  { render :xml => @imagen, :status => :created, :location => @imagen }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @imagen.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /imagenes/1
  # PUT /imagenes/1.xml
  def update
    @imagen = Imagen.find(params[:id])

    respond_to do |format|
      if @imagen.update_attributes(params[:imagen])
        format.html { redirect_to(@imagen, :notice => 'Imagen actualizada exitosamente.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @imagen.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /imagenes/1
  # DELETE /imagenes/1.xml
  def destroy
    @imagen = Imagen.find(params[:id])
    @imagen.destroy

    respond_to do |format|
      format.html { redirect_to(album_path(@imagen), :notice => 'Imagen eliminada exitosamente.') }
      format.xml  { head :ok }
    end
  end
  
  def ajax_upload
    #ext = params[:file].original_filename.split('.').last.downcase
    #params[:file].content_type = "image/" + ext
    
    @imagen = Imagen.new(:album_id => params[:album_id],
      :album_type => params[:album_type],
      :imagen => params[:file])
    @imagen.usuario = current_user
    
    if @imagen.save
      render :text => "ok"
    else
      render :text => "error", :status => 500
    end
  end
  
  def lista
    @taxon = Taxon.find params[:taxon_id]
    @imagenes = @taxon.imagenes
  end
  
  # PUT /imagenes/?orden=Y
  def ordenar
    taxon = Taxon.find params[:taxon]
    imagenes_ids = params[:orden].split(',')
    i = 1
    imagenes_ids.each do |imagen_id|
      return unless imagen_id
      imagen = Imagen.update_all("posicion = #{i}", "id = #{imagen_id}")
      i = i+1
    end
    #para limpiar el cache
    taxon.imagenes.first.update_attribute(:updated_at, Time.now)
    
    flash[:success] = "Imagenes reordenadas exitosamente"
    redirect_to taxon
  end
  
  
  private

  def find_album
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
  
  def album_path(imagen)
    if imagen.album_type == "Taxon"
      metodo = :taxon_imagenes_path
    else
      metodo = :clave_path
    end
    send(metodo, imagen.album)
  end
  
end
