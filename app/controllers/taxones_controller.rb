class TaxonesController < ApplicationController
  
  include TaxonesHelper

  filter_resource_access
  
  caches_action :resumen, :galeria
  cache_sweeper :taxon_sweeper, :only => [:create, :update, :destroy]
  
  # GET /taxones
  # GET /taxones.xml
  def index
    @page = params[:page] || 1
    if params[:categoria_id]
      @categoria = Categoria.find(params[:categoria_id])
      @taxones = @categoria.taxones 
    else
      @taxones = Taxon.where(:parent_id => nil).includes(:categoria)
    end
    @taxones = @taxones.ordenados.page @page

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taxones }
    end
  end

  # GET /taxones/1
  # GET /taxones/1.xml
  def show
    @taxon = Taxon.find(params[:id])
    @page = params[:page] || 1
    if @taxon.categoria.final? 
      @asoc = params[:asoc] || "ejemplares"
    else
      @subcatSelecId = params[:categoria]      
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @taxon }
    end
  end

  # GET /taxones/new
  # GET /taxones/new.xml
  def new
    @taxon = Taxon.new
    
    if params[:taxon_id]
      padre = Taxon.find(params[:taxon_id])
      @taxon.parent = padre
    end
    
    if params[:categoria]
      categoria = Categoria.find(params[:categoria])
      @taxon.categoria = categoria
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @taxon }
    end
  end

  # GET /taxones/1/edit
  def edit
    @taxon = Taxon.find(params[:id])
  end

  # POST /taxones
  # POST /taxones.xml
  def create
    @taxon = Taxon.new(params[:taxon])
    @taxon.usuario = current_user

    respond_to do |format|
      if @taxon.save
        format.html { redirect_to(@taxon, :notice => "<b>#{ @taxon.categoria.nombre } #{ @taxon.nombre }</b> fue creado exitosamente.") }
        format.xml  { render :xml => @taxon, :status => :created, :location => @taxon }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @taxon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /taxones/1
  # PUT /taxones/1.xml
  def update
    @taxon = Taxon.find(params[:id])
    
    respond_to do |format|
      if @taxon.update_attributes(params[:taxon])
        
        if @taxon.aplicar_visibilidad_a_hijos_y_padres
          @taxon.ancestors.update_all ['visible = ?', @taxon.visible]
          @taxon.descendants.update_all ['visible = ?', @taxon.visible]
        end
        
        format.html { redirect_to(@taxon, :notice => "<b>#{ @taxon.categoria.nombre } #{ @taxon.nombre }</b> fue actualizado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @taxon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /taxones/1
  # DELETE /taxones/1.xml
  def destroy
    @taxon = Taxon.find(params[:id])
    
    respond_to do |format|
      if @taxon.eliminar
        format.html { redirect_to(@taxon.parent_id ? @taxon.parent : taxones_url, :notice => "<b>#{ @taxon.categoria.nombre } #{ @taxon.nombre }</b> fue eliminado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { redirect_to(@taxon, :alert => @taxon.errors.full_messages) }
        format.xml  { render :xml => @taxon.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # RESUMEN /taxones/1/resumen
  def resumen
    @taxon = Taxon.find(params[:id])
    render :action => "resumen", :layout => false
  end
  
  #GALERIA
  def galeria
    @taxon = Taxon.find(params[:id])
    @imagenes = @taxon.imagenes(:limit => 50).includes(:album)
    respond_to do |format|
      format.html { redirect_to(@taxon) }
      format.xml
    end
  end
  
end
