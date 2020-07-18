class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale, :set_locale_var
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_plants, :set_plant, :user_plants_associated, :set_nav_variables
  around_action :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to pages_no_permission_path, notice: exception.message
  end

  private

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def set_locale_var
    @locale = set_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ?
      parsed_locale.to_sym :
      nil
  end

  protected

  def set_plant
    @plant = nil
    @plant = Plant.find(params[:plant_id]) if params[:plant_id].present?
    @plant = Plant.find(params[:id]) if params[:controller] == 'plants' && params[:id].present?
  end

  def set_user_plants
    plant = set_plant
    plant_id = plant ? plant.id : 0
    @user_plants = current_user.plants.filter_by_id(plant_id).sort if current_user.present?
  end

  def user_plants_associated
    user_plants = current_user.plants if current_user.present?
    flash.now[:alert] = 'This user has no associated Plants.' if (user_plants.nil? || user_plants.empty?) && user_signed_in?
  end

  def set_nav_variables
    @menu = {}
    @menu[params[:controller].to_sym] = true
    @menu[:tickets] = true if %w[alerts supports inspections].include? params[:controller]
    @menu[:action] = params[:action]
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :lastname, :address01, :address02, :phone, :mobile, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :lastname, :address01, :address02, :phone, :mobile, :email, :password, :current_password) }
  end

  def set_current_user
    Current.user = current_user
    yield
  ensure
    # to address the thread variable leak issues in Puma/Thin webserver
    Current.user = nil
  end
end
