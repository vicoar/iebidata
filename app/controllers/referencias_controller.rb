class ReferenciasController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :referencia_sweeper, :only => [:create, :update, :destroy]
  # GET /referencias
  # GET /referencias.xml
  def index
    if params[:taxon_id]
      taxon = Taxon.find params[:taxon_id]
      @referencias = taxon.referencias.page(params[:page])
    else
      @referencias = Referencia.page(params[:page])
    end    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @referencias }
    end
  end

  # GET /referencias/1
  # GET /referencias/1.xml
  def show
    @referencia = Referencia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @referencia }
    end
  end

  # GET /referencias/new
  # GET /referencias/new.xml
  def new
    taxon = Taxon.find params[:taxon_id] 
    @referencia = taxon.referencias.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @referencia }
    end
  end

  # GET /referencias/1/edit
  def edit
    @referencia = Referencia.find(params[:id])
  end

  # POST /referencias
  # POST /referencias.xml
  def create
    @referencia = Referencia.new(params[:referencia])
    @referencia.usuario = current_user

    respond_to do |format|
      if @referencia.save
        format.html { redirect_to(@referencia, :notice => "Referencia <b>#{@referencia.nombre}</b> creada exitosamente.") }
        format.xml  { render :xml => @referencia, :status => :created, :location => @referencia }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @referencia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /referencias/1
  # PUT /referencias/1.xml
  def update
    @referencia = Referencia.find(params[:id])

    respond_to do |format|
      if @referencia.update_attributes(params[:referencia])
        format.html { redirect_to(@referencia, :notice => "Referencia <b>#{@referencia.nombre}</b> actualizada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @referencia.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /referencias/1
  # DELETE /referencias/1.xml
  def destroy
    @referencia = Referencia.find(params[:id])
    @referencia.destroy

    respond_to do |format|
      format.html { redirect_to(@referencia.taxon, :notice => "Referencia <b>#{@referencia.nombre}</b> eliminada exitosamente.") }
      format.xml  { head :ok }
    end
  end
end
