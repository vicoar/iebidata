class RegionesController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :region_sweeper, :only => [:create, :update, :destroy]
  
  # GET /regiones
  # GET /regiones.xml
  def index
    if params[:pais_id]
      pais = Pais.find params[:pais_id]
      @regiones = pais.regiones.page params[:page]
    else
      @regiones = Region.page params[:page]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @regions }
    end
  end

  # GET /regiones/1
  # GET /regiones/1.xml
  def show
    @region = Region.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @region }
    end
  end

  # GET /regiones/new
  # GET /regiones/new.xml
  def new
    pais = Pais.find params[:pais_id]
    @region = pais.regiones.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @region }
    end
  end

  # GET /regiones/1/edit
  def edit
    @region = Region.find(params[:id])
  end

  # POST /regiones
  # POST /regiones.xml
  def create
    @region = Region.new(params[:region])

    respond_to do |format|
      if @region.save
        format.html { redirect_to(@region, :notice => "Region <b>#{@region.nombre}</b> creada exitosamente.") }
        format.xml  { render :xml => @region, :status => :created, :location => @region }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @region.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /regiones/1
  # PUT /regiones/1.xml
  def update
    @region = Region.find(params[:id])

    respond_to do |format|
      if @region.update_attributes(params[:region])
        format.html { redirect_to(@region, :notice => "Region <b>#{@region.nombre}</b> actualizada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @region.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /regiones/1
  # DELETE /regiones/1.xml
  def destroy
    @region = Region.find(params[:id])
    
    respond_to do |format|
      if @region.destroy
        format.html { redirect_to(pais_path(@region.pais), :notice => "Region <b>#{@region.nombre}</b> eliminada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@region, :alert => @region.errors.full_messages) }
        format.xml  { render :xml => @region.errors, :status => :unprocessable_entity }
      end
    end    
  end
  
end
