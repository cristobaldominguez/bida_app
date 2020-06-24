class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_plants, only: [:create, :update]
  before_action :set_employees, only: [:new, :create, :edit, :update]
  before_action :grouped_plants, :set_roles, :set_interface_colors, only: [:new, :create, :edit, :update]
  before_action :check_user_ability, only: [:create, :update]
  before_action :set_locales
  authorize_resource
  skip_authorize_resource only: :uicolor

  # GET /users
  # GET /users.json
  def index
    @users = User.sort_by_id
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.plants = params[:user][:plant_ids].reject(&:blank?).map { |e| @plants.find(e) }

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user.plants = params[:user][:plant_ids].reject(&:blank?).map { |e| @plants.find(e) } if params[:user][:plant_ids]

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.inactive!
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def uicolor
    if current_user.dark?
      current_user.light!
      @user_ui = {
        color: 'light',
        icon: 'moon'
      }
    else
      current_user.dark!
      @user_ui = {
        color: 'dark',
        icon: 'sun'
      }
    end

    respond_to do |format|
      format.json { render json: @user_ui }
    end
  end

  private

  def set_locales
    @locales = I18n.available_locales.map {|locale| [locale, User.human_enum_name(:locales, locale)] }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id]) || current_user.id
  end

  def set_plants
    @plants = Plant.active.includes(:country)
  end

  def grouped_plants
    @grouped_plants = Plant.active.includes(:country).group_by { |p| p.country.name }
  end

  def set_roles
    @roles = User.roles.map { |role, _| [role, User.human_enum_name(:roles, role).to_s.humanize] }
  end

  def set_employees
    @employees = User.employees.map { |employee| [employee.first, User.human_enum_name(:employees, employee.first).humanize] }
  end

  def set_interface_colors
    @interface_colors = User.interface_colors.map { |color, _| [color, User.human_enum_name(:interface_colors, color).to_s.humanize] }
  end

  def check_user_ability
    if params[:user][:role] == 'admin' && !current_user.admin?
      flash.now[:alert] = I18n.t(:not_allowed_admin_creation, scope: [:activerecord, :models, :attributes])
      render :new
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :lastname, :email, :active, :address01, :address02,
                                 :phone, :interface_color, :mobile, :plants, :role,
                                 :password, :password_confirmation, :employee, :filtered)
  end
end
