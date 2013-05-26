class InvitacionesController < ApplicationController
  
  filter_access_to :all
  
  def index
    @invitaciones = Invitacion.solicitadas.page(params[:page])  
  end
  
  def new
    @invitacion = Invitacion.new
  end

  def create
    @invitacion = Invitacion.new(params[:invitacion])
    @invitacion.remitente = current_user
    if @invitacion.save
      if logged_in?
        @invitacion.enviar
        redirect_to invitaciones_path, :notice => "Invitacion enviada a #{@invitacion.destinatario_email}."
      else
        redirect_to root_url, :notice => "Muchas gracias. Te avisaremos si tu solicitud es aceptada"
      end
    else
      render :action => 'new'
    end
  end
  
  def enviar
    @invitacion = Invitacion.find params[:id]
    @invitacion.remitente = current_user
    if @invitacion.save
      @invitacion.enviar
      flash[:notice] = "Invitacion enviada a #{@invitacion.destinatario_email}."
    else
      flash[:alert] = "Sucedio un error. Contacte al administrador"
    end    
    redirect_to invitaciones_path
  end
  
  def destroy
    @invitacion = Invitacion.find params[:id]
    
    if @invitacion.destroy
      redirect_to invitaciones_path, :notice => "Invitacion para #{@invitacion.destinatario_email} cancelada."
    else
      redirect_to invitaciones_path, :alert => @invitacion.errors.full_messages
    end
  end
end
