class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_plants, only: [:create, :update]
  before_action :grouped_plants, :set_roles, :set_interface_colors, only: [:edit, :new, :create]
  authorize_resource

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:users_plants, :plants).active.sort_by_id
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
    plants_params = params[:user][:plant_ids].reject(&:blank?).map { |e| @plants.find(e) }
    @user.plants = plants_params unless plants_params.blank?

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
    plants_params = params[:user][:plant_ids].reject(&:blank?).map { |e| @plants.find(e) }
    @user.plants = plants_params unless plants_params.blank?

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
    @user.active = false
    @user.save
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id]) || current_user.id
  end

  def set_plants
    @plants = Plant.active
  end

  def grouped_plants
    @plants = Plant.active.includes(:country).group_by { |p| p.country.name }
  end

  def set_roles
    @roles = User.roles.map { |role, k| [role, role.to_s.humanize] }
  end

  def set_interface_colors
    @interface_colors = User.interface_colors.map { |color, k| [color, color.to_s.humanize] }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :lastname, :email, :active, :address01, :address02, :phone,
                                 :interface_color, :mobile, :plants, :role, :password, :password_confirmation)
  end
end
