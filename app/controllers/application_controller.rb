class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_plants, :set_plant

  protected

  def set_plant
    @plant = params[:plant_id].present? ? Plant.find(params[:plant_id]) : params[:controller] == 'plants' && params[:id].present? ? Plant.find(params[:id]) : nil
  end

  def set_user_plants
    @user_plants = current_user.plants unless current_user.nil?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :lastname, :address01, :address02, :phone, :mobile, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :lastname, :address01, :address02, :phone, :mobile, :email, :password, :current_password) }
  end
end
