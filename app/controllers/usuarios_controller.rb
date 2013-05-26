class UsuariosController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :usuario_sweeper, :only => [:create, :update, :destroy]
  
  # GET /usuarios
  # GET /usuarios.xml
  def index
    @usuarios = Usuario.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @usuarios }
    end
  end

  # GET /usuarios/1
  # GET /usuarios/1.xml
  def show
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @usuario }
    end
  end

  # GET /usuarios/new
  # GET /usuarios/new.xml
  def new
    @usuario = Usuario.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @usuario }
    end
  end

  # GET /usuarios/1/edit
  def edit
    @usuario = Usuario.find(params[:id])
  end

  # POST /usuarios
  # POST /usuarios.xml
  def create
    @usuario = Usuario.new(params[:usuario])

    if @usuario.save
      redirect_to(@usuario, :notice => "Usuario <b>#{@usuario.nombre}</b> creado exitosamente.")
    else
      render :action => "new"
    end
  end

  # PUT /usuarios/1
  # PUT /usuarios/1.xml
  def update
    @usuario = Usuario.find(params[:id])
        
    respond_to do |format|
      if @usuario.update_attributes(params[:usuario])
        format.html { redirect_to(@usuario, :notice => "Usuario <b>#{@usuario.nombre}</b> actualizado exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.xml
  def destroy
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      if @usuario.destroy
        format.html { redirect_to(usuarios_url) }
        format.xml  { head :ok }        
      else
        format.html { redirect_to(@usuario, :alert => @usuario.errors.full_messages) }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end
  end
    
end
