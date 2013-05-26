class EjemplaresController < ApplicationController
  
  filter_access_to :all
  
  caches_action :galeria  
  cache_sweeper :ejemplar_sweeper, :only => [:create, :update, :destroy]
  
  # GET /ejemplares
  # GET /ejemplares.xml
  def index
    @ejemplares = Ejemplar.includes(:taxon,:muestra).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ejemplares }
    end
  end

  # GET /ejemplares/1
  # GET /ejemplares/1.xml
  def show
    @ejemplar = Ejemplar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ejemplar }
    end
  end

  # GET /ejemplares/new
  # GET /ejemplares/new.xml
  def new
    if params[:muestra_id]
      @muestra = Muestra.find params[:muestra_id]
      @ejemplar = @muestra.ejemplares.build
    end
    
    if params[:taxon_id]
      @taxon = Taxon.find params[:taxon_id]
      @ejemplar = @taxon.ejemplares.build
    end
    
    @ejemplar ||= Ejemplar.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ejemplar }
    end
  end

  # GET /ejemplares/1/edit
  def edit
    @ejemplar = Ejemplar.find(params[:id])    
  end

  # POST /ejemplares
  # POST /ejemplares.xml
  def create
    @ejemplar = Ejemplar.new(params[:ejemplar])
    @ejemplar.usuario  = current_user

    respond_to do |format|
      if @ejemplar.save
        format.html { redirect_to(@ejemplar, :notice => "Ejemplar <b>#{@ejemplar.nombre}</b> creado exitosamente.") }
        format.xml  { render :xml => @ejemplar, :status => :created, :location => @ejemplar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ejemplar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ejemplares/1
  # PUT /ejemplares/1.xml
  def update
    @ejemplar = Ejemplar.find(params[:id])

    respond_to do |format|
      if @ejemplar.update_attributes(params[:ejemplar])
        format.html { redirect_to(@ejemplar, :notice => "Ejemplar <b>#{@ejemplar.nombre}</b> actualizado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ejemplar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ejemplares/1
  # DELETE /ejemplares/1.xml
  def destroy
    @ejemplar = Ejemplar.find(params[:id])
    @ejemplar.destroy

    respond_to do |format|
      format.html { redirect_to(@ejemplar.muestra, :notice => "Ejemplar <b>#{@ejemplar.nombre}</b> eliminado exitosamente.") }
      format.xml  { head :ok }
    end
  end
   
  def ficha
    @ejemplar = Ejemplar.find(params[:id])
  end
  
end
