class CuentasController < ApplicationController
  
  filter_access_to :all
  
  cache_sweeper :usuario_sweeper, :only => [:create, :update]
  
  # GET /cuenta/show
  # GET /cuenta/show.xml
  def show
    if current_user
      @usuario = current_user
    else
      redirect_to login_path
    end
  end
  
  # GET /cuenta/new
  # GET /cuenta/new.xml
  def new
    @usuario = Usuario.new(:invitacion_pase => params[:pase])
    if @usuario.invitacion
      @usuario.email = @usuario.invitacion.destinatario_email
      @usuario.nombre = @usuario.invitacion.nombre
    else
      redirect_to root_path, :alert => "No puedes inscribirte sin una invitacion."
      return false
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @usuario }
    end
  end

  # GET /cuenta/edit
  def edit
    @usuario = current_user
  end

  # POST /cuenta
  # POST /cuenta.xml
  def create
    @usuario = Usuario.new(params[:usuario])

    if @usuario.save
      redirect_to(root_path, :notice => "Registracion exitosa. Bienvenido al sistema <b>#{@usuario.nombre}</b>")
    else
      render :action => "new"
    end
  end

  # PUT /cuenta
  # PUT /cuenta.xml
  def update
    @usuario = current_user
    
    respond_to do |format|
      if @usuario.update_attributes(params[:usuario])
        format.html { redirect_to(cuenta_path, :notice => "Tu cuenta fue actualizada exitosamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
