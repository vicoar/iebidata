class RecuperarCuentaController < ApplicationController
  
  filter_access_to :all
  
  before_filter :cargar_usuario, :only => [ :edit, :update ]
  
  def new
  end

  def create
    @usuario = Usuario.where(:email => params[:email]).first
    if @usuario
      @usuario.enviar_instrucciones_recuperar_cuenta
      redirect_to root_path, :notice => "Se te envio un correo con las instrucciones para recuperar tu cuenta."
    else
      flash.now[:alert] = "No existe usuario con el email #{params[:email]}"
      render :action => :new
    end
  end
  
  def edit
  end

  def update
    @usuario.password = params[:password]
    @usuario.password_confirmation = params[:password_confirmation]
    if @usuario.save
      #@usuario.save_without_session_maintenance #para guardar cambios sin loggear el usuario
      redirect_to root_path, :notice => "Tu contrase&ntilde;a fue actualizada exitosamente." 
    else
      render :action => :edit
    end
  end

  private

  def cargar_usuario
    @usuario = Usuario.where(:perishable_token => params[:id]).first
    unless @usuario
      redirect_to root_url, :alert => "Lo siento, no pude encontrar tu cuenta." 
    end
  end
  
end
