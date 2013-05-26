class BusquedasController < ApplicationController
  def new
    @busqueda = Busqueda.new
  end

  def create
    @busqueda = Busqueda.new(params[:busqueda])
    @busqueda.usuario = current_user
    if @busqueda.save
      redirect_to @busqueda
    else
      render :action => 'new'
    end
  end

  def show
    @busqueda = Busqueda.find(params[:id])
  end
end
