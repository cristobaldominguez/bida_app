class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_plants, :set_plant, :set_latest_flow_report

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to pages_no_permission_path, notice: exception.message
  end

  protected

  def set_plant
    @plant = params[:plant_id].present? ? Plant.find(params[:plant_id]) : params[:controller] == 'plants' && params[:id].present? ? Plant.find(params[:id]) : nil
  end

  def set_user_plants
    @user_plants = current_user.plants.last(5) unless current_user.nil?
    flash.now[:alert] = 'This user has no associated Plants.' if (@user_plants.nil? || @user_plants.empty?) && user_signed_in?
  end

  def set_latest_flow_report
    flow_report = FlowReport.active.created_between(Date.today.at_beginning_of_month.beginning_of_day, Time.now)
    @latest_flow_report = flow_report.first || nil
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :lastname, :address01, :address02, :phone, :mobile, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :lastname, :address01, :address02, :phone, :mobile, :email, :password, :current_password) }
  end
end
