class SinonimosController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :sinonimo_sweeper, :only => [:create, :update, :destroy]
  
  # GET /sinonimos
  # GET /sinonimos.xml
  def index
    if params[:taxon_id]
      taxon = Taxon.find params[:taxon_id]
      @sinonimos = taxon.sinonimos.page(params[:page])
    else
      @sinonimos = Sinonimo.includes(:taxon).page(params[:page])
    end    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sinonimos }
    end
  end

  # GET /sinonimos/1
  # GET /sinonimos/1.xml
  def show
    @sinonimo = Sinonimo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sinonimo }
    end
  end

  # GET /sinonimos/new
  # GET /sinonimos/new.xml
  def new
    taxon = Taxon.find params[:taxon_id]
    @sinonimo = taxon.sinonimos.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sinonimo }
    end
  end

  # GET /sinonimos/1/edit
  def edit
    @sinonimo = Sinonimo.find(params[:id])
  end

  # POST /sinonimos
  # POST /sinonimos.xml
  def create
    @sinonimo = Sinonimo.new(params[:sinonimo])
    @sinonimo.usuario = current_user

    respond_to do |format|
      if @sinonimo.save
        format.html { redirect_to(@sinonimo, :notice => "Sinonimo <b>#{@sinonimo.nombre}</b> creado exitosamente.") }
        format.xml  { render :xml => @sinonimo, :status => :created, :location => @sinonimo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sinonimo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sinonimos/1
  # PUT /sinonimos/1.xml
  def update
    @sinonimo = Sinonimo.find(params[:id])

    respond_to do |format|
      if @sinonimo.update_attributes(params[:sinonimo])
        format.html { redirect_to(@sinonimo, :notice => "Sinonimo <b>#{@sinonimo.nombre}</b> actualizado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sinonimo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sinonimos/1
  # DELETE /sinonimos/1.xml
  def destroy
    @sinonimo = Sinonimo.find(params[:id])
    @sinonimo.destroy

    respond_to do |format|
      format.html { redirect_to(@sinonimo.taxon, :notice => "Sinonimo <b>#{@sinonimo.nombre}</b> eliminado exitosamente.") }
      format.xml  { head :ok }
    end
  end
end
