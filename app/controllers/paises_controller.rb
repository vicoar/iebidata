class PaisesController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :region_sweeper, :only => [:create, :update, :destroy]
  
  # GET /pais
  # GET /pais.xml
  def index
    @paises = Pais.page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pais }
    end
  end

  # GET /pais/1
  # GET /pais/1.xml
  def show
    @pais = Pais.find(params[:id])
    @regiones = @pais.regiones.page params[:page]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pais }
    end
  end

  # GET /pais/new
  # GET /pais/new.xml
  def new
    @pais = Pais.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pais }
    end
  end

  # GET /pais/1/edit
  def edit
    @pais = Pais.find(params[:id])
  end

  # POST /pais
  # POST /pais.xml
  def create
    @pais = Pais.new(params[:pais])

    respond_to do |format|
      if @pais.save
        format.html { redirect_to(pais_path(@pais), :notice => "Pais <b>#{@pais.nombre}</b> creado exitosamente.") }
        format.xml  { render :xml => @pais, :status => :created, :location => @pais }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pais.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pais/1
  # PUT /pais/1.xml
  def update
    @pais = Pais.find(params[:id])

    respond_to do |format|
      if @pais.update_attributes(params[:pais])
        format.html { redirect_to(pais_path(@pais), :notice => "Pais <b>#{@pais.nombre}</b> actualizado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pais.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pais/1
  # DELETE /pais/1.xml
  def destroy
    @pais = Pais.find(params[:id])

    respond_to do |format|      
      if @pais.destroy
        format.html { redirect_to({:action => "index"}, :notice => "Pais <b>#{@pais.nombre}</b> eliminado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { 
          redirect_to(pais_path(@pais), :alert => @pais.errors.full_messages) 
        }
        format.xml  { render :xml => @pais.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
