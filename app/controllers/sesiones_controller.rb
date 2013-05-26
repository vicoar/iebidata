class SesionesController < ApplicationController
  
  filter_access_to :all
  
  def new
    @sesion = UsuarioSession.new
  end
  
  def create
    @sesion = UsuarioSession.new(params[:usuario_session])
    if @sesion.save
      @usuario = @sesion.record
      redirect_to root_url, :notice => "Ingreso exitoso. Bienvenido otra vez #{@usuario.nombre}"
    else
      render :action => 'new'
    end
  end
  
  def destroy
    flash[:notice] = "Salida exitosa. Hasta luego..."
    current_user_session.destroy
    redirect_to root_url
  end
end
