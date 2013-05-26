class MuestrasController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :muestra_sweeper, :only => [:create, :update, :destroy]
  
  # GET /muestras
  # GET /muestras.xml
  def index
    @muestras = Muestra.includes(:sitio).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @muestras }
    end
  end

  # GET /muestras/1
  # GET /muestras/1.xml
  def show
    @muestra = Muestra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @muestra }
    end
  end

  # GET /muestras/new
  # GET /muestras/new.xml
  def new
    @sitio = Sitio.find params[:sitio_id]
    @muestra = @sitio.muestras.build
    @muestra.colector = current_user
    @muestra.identificador = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @muestra }
    end
  end

  # GET /muestras/1/edit
  def edit
    @muestra = Muestra.find(params[:id])
  end

  # POST /muestras
  # POST /muestras.xml
  def create
    @muestra = Muestra.new(params[:muestra])
    @muestra.usuario = current_user

    respond_to do |format|
      if @muestra.save
        format.html { redirect_to(@muestra, :notice => "Muestra <b>#{@muestra.nombre}</b> creada exitosamente.") }
        format.xml  { render :xml => @muestra, :status => :created, :location => @muestra }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @muestra.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /muestras/1
  # PUT /muestras/1.xml
  def update
    @muestra = Muestra.find(params[:id])

    respond_to do |format|
      if @muestra.update_attributes(params[:muestra])
        format.html { redirect_to(@muestra, :notice => "Muestra <b>#{@muestra.nombre}</b> actualizada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @muestra.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /muestras/1
  # DELETE /muestras/1.xml
  def destroy
    @muestra = Muestra.find(params[:id])

    respond_to do |format|
      if @muestra.destroy
        format.html { redirect_to(@muestra.sitio, :notice => "Muestra <b>#{@muestra.nombre}</b> eliminada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@muestra, :alert => @muestra.errors.full_messages) }
        format.xml  { head :ok }
      end      
    end
  end
end
