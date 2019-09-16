class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_user_plants, :set_plant, :set_logbook_path, :set_samplings_lists, :set_latest_report, :set_latest_flow_report

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to pages_no_permission_path, notice: exception.message
  end

  protected

  def set_samplings_lists
    # @lab_samplings = check_sampling_link(@plant, 'Lab')
    # @internal_samplings = check_sampling_link(@plant, 'Internal')
  end

  def set_plant
    @plant = params[:plant_id].present? ? Plant.find(params[:plant_id]) : params[:controller] == 'plants' && params[:id].present? ? Plant.find(params[:id]) : nil
  end

  def set_user_plants
    @user_plants = current_user.plants.last(5) unless current_user.nil?
    flash.now[:alert] = 'This user has no associated Plants.' if (@user_plants.nil? || @user_plants.empty?) && user_signed_in?
  end

  def set_latest_report
    report = Report.active.created_between(Date.today.at_beginning_of_month.beginning_of_day, Time.now)
    @latest_report = report.first || nil
  end

  def set_latest_flow_report
    flow_report = FlowReport.active.created_between(Date.today.at_beginning_of_month.beginning_of_day, Time.now)
    @latest_flow_report = flow_report.first || nil
  end

  def set_logbook_path
    return nil unless params[:plant_id].present? || params[:id].present?

    @plant = params[:plant_id].present? ? Plant.find(params[:plant_id]) : params[:controller] == 'plants' && params[:id].present? ? Plant.find(params[:id]) : nil
    return nil if @plant.nil?

    @logbook_path = @plant.logbooks.last.created_at.month == Date.today.month ? edit_plant_logbook_path(@plant, @plant.logbooks.last) : new_plant_logbook_path(@plant)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :lastname, :address01, :address02, :phone, :mobile, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :lastname, :address01, :address02, :phone, :mobile, :email, :password, :current_password) }
  end

  def check_sampling_link(plant, target)
    current_date = Date.today
    return nil if plant.nil?

    sampling_target = target == 'Lab' ? plant.sampling_lists.lab : plant.sampling_lists.internal
    frecuency_name = sampling_target.first.frecuency.name
    sampling_cycle = sampling_target.first.per_cycle
    start_date = def_start_date(frecuency_name)

    sampling_lists = sampling_target.select { |elem| elem.created_at.to_date.between?(start_date, current_date) }
    sampling_param = sampling_lists.size < sampling_cycle ? generate_new_sampling_lists(target) : sampling_target.last
    edit_plant_sampling_list_path(@plant, sampling_param)
  end

  def generate_new_sampling_lists(target)
    sampling_target = target == 'Lab' ? @plant.sampling_lists.lab : @plant.sampling_lists.internal
    plant_samplings = sampling_target.includes(:samplings)
    sampling_list = plant_samplings.max_by(&:created_at)
    date = Date.today

    new_sl = SamplingList.create(plant_id: sampling_list.plant_id,
                                 date: Date.new(date.year, date.month, 1),
                                 access_id: sampling_list.access_id,
                                 frecuency_id: sampling_list.frecuency_id,
                                 per_cycle: sampling_list.per_cycle)

    sampling_list.samplings.each do |sampling|
      new_sl.samplings.create(standard_id: sampling.standard_id, value_in: 0.0, value_out: 0.0)
    end

    new_sl
  end

  def def_start_date(frecuency_name)
    start_date = Date.new
    current_date = Date.today

    case frecuency_name
    when 'Daily'    then start_date = current_date.beginning_of_day
    when 'Weekly'   then start_date = current_date.beginning_of_week
    when 'Monthly'  then start_date = current_date.at_beginning_of_month
    when 'Annualy'  then start_date = current_date.beginning_of_year
    end

    start_date
  end
end
