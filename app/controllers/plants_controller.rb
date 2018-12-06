class PlantsController < ApplicationController
  before_action :set_plant, only: %i[show edit update destroy]
  before_action :set_company, only: %i[show create update destroy]
  before_action :set_companies, only: :index
  before_action :set_discharge_points, :set_countries, only: %i[new edit create update]

  # GET companies/:company_id/plants
  # GET companies/:company_id/plants.json
  def index
    @plants = Company.find(params[:company_id]).plants.active
    @company = Company.find(params[:company_id])
  end

  # GET companies/:company_id/plants/1
  # GET companies/:company_id/plants/1.json
  def show
    @alerts = @plant.alerts.active
    @supports = @plant.supports.active
  end

  # GET companies/:company_id/plants/new
  def new
    @company = Company.find(params[:company_id])
    @plant = @company.plants.build
    @attention = @company.plants.users
  end

  # GET companies/:company_id/plants/1/edit
  def edit
    @plant = Plant.find(params[:id])
    @company = @plant.company
  end

  # POST companies/:company_id/plants
  # POST companies/:company_id/plants.json
  def create
    @plant = @company.plants.build(plant_params)
    respond_to do |format|
      if @plant.save
        format.html { redirect_to @plant, notice: 'Plant was successfully created.' }
        format.json { render :show, status: :created, location: @plant }
      else
        format.html { render :new }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT companies/:company_id/plants/1
  # PATCH/PUT companies/:company_id/plants/1.json
  def update
    @plant.system_size = params[:plant][:system_size].split(' ').map(&:to_i)
    respond_to do |format|
      if @plant.update(plant_params)
        format.html { redirect_to @plant, notice: 'Plant was successfully updated.' }
        format.json { render :show, status: :ok, location: @plant }
      else
        format.html { render :edit }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE companies/:company_id/plants/1
  # DELETE companies/:company_id/plants/1.json
  def destroy
    @plant.active = false
    @plant.save
    respond_to do |format|
      format.html { redirect_to company_path(@company), notice: 'Plant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_plant
    @plant = Plant.find(params[:id])
  end

  def set_company
    @company = params[:company_id].nil? ? Plant.find(params[:id]).company : Company.find(params[:company_id])
  end

  def set_companies
    @companies = Company.all
  end

  def set_countries
    @countries = Country.all
  end

  def set_discharge_points
    @points = DischargePoint.all
  end

  def plant_params
    params.require(:plant).permit(
      :name, :code, :company_id, :address01, :address02, :state, :zip, :phone,
      :flow_design, :startup_date, :country_id, :discharge_point_id, system_size: []
    )
  end
end
