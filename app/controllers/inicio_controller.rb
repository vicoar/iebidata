class InicioController < ApplicationController
  
  filter_access_to :all
  
  def bienvenido
    if current_user_session && current_user.tipo?(:administrador)
      redirect_to panel_path
    else
      redirect_to cuenta_path
    end
  end
  
  def panel
  end
  
  def error
    if params[:error]
      Mailer.error(params[:error]).deliver
      redirect_to root_path, :notice => 'Se envio un mensaje al administrador.'
    end
  end
  
end
