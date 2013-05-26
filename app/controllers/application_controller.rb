# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # helper :all # include all helpers, all the time
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user

  before_filter {|c| Authorization.current_user = c.current_user }
  
  after_filter :usuario_tipo
  
  after_filter :write_flash_to_cookie
  
  #ActiveRecord exceptions
  #rescue_from ActiveRecord::RecordNotFound, :with => :not_found #400   

  #ActiveResource exceptions  
  #rescue_from ActiveResource::ResourceNotFound, :with => :not_found #404

  #ActionView exceptions
  #rescue_from ActionView::TemplateError, :with => :not_found #500

  #ActionController exceptions
  #rescue_from ActionController::RoutingError, :with => :not_found #404   

  #rescue_from ActionController::UnknownController, :with => :not_found #404 

  #rescue_from ActionController::MethodNotAllowed, :with => :not_found #405   

  #rescue_from ActionController::InvalidAuthenticityToken, :with => :not_found #405

  #rescue_from ActionController::UnknownAction, :with => :not_found #501

  # This particular exception causes all the rest to fail.... why?
  # rescue_from ActionController::MissingTemplate, :with => :not_found #404

  protected
  
  def usuario_tipo
    if current_user_session
      cookies[:usuario_tipo] = current_user.tipo
    else
      cookies.delete :usuario_tipo
    end
  end
  
  def not_found
      #render :actio => "Error", :status => 404
      redirect_to error_path, :alert => "El recurso que intentaste usar no existe. Comprueba la direccion y vuelve a intentar. Si considera que esto es un error reportelo."
  end    
  
  def redirect_back_or(path = root_path)
    redirect_to :back
    rescue ActionController::RedirectBackError
    redirect_to path
  end
  
  def permission_denied
    flash[:alert] = "No tienes permiso para acceder esa pagina."
    redirect_to root_path
  end

  def write_flash_to_cookie
    cookie_flash = cookies['flash'] ? ActiveSupport::JSON.decode(cookies['flash']) : {}

    flash.each do |key, value|
      if cookie_flash[key.to_s].blank?
        cookie_flash[key.to_s] = value
      else
        cookie_flash[key.to_s] << "<br/>#{value}"
      end
    end

    cookies['flash'] = cookie_flash.to_json
    flash.clear
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UsuarioSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def logged_in?
    current_user
  end

end
