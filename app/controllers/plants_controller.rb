class PlantsController < ApplicationController
  before_action :set_plant, only: [:show, :edit, :update, :destroy]
  before_action :set_company, only: [:show, :edit,:new, :update, :destroy]
  before_action :set_companies, only: [:new, :edit, :index, :show]
  before_action :set_countries, only: [:new, :edit, :index, :show]
  before_action :set_discharge_points, only: [:new, :edit, :show]

  # GET /plants
  # GET /plants.json
  def index
    @plants = Company.find(params[:company_id]).plants.active
    @company = Company.find(params[:company_id])
  end

  # GET /plants/1
  # GET /plants/1.json
  def show
  end

  # GET /plants/new
  def new
    @plant = Plant.new
    @companies = Company.all
  end

  # GET /plants/1/edit
  def edit
    @plant = Plant.find(params[:id])
  end

  # POST /plants
  # POST /plants.json
  def create
    @plant = Plant.new(plant_params)
    @plant.company_id = params[:company_id]
    respond_to do |format|
      if @plant.save
        format.html { redirect_to company_plant_path(@plant), notice: 'Plant was successfully created.' }
        format.json { render :show, status: :created, location: @plant }
      else
        format.html { render :new }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plants/1
  # PATCH/PUT /plants/1.json
  def update
    respond_to do |format|
      if @plant.update(plant_params)
        format.html { redirect_to company_plant_path(@plant), notice: 'Plant was successfully updated.' }
        format.json { render :show, status: :ok, location: @plant }
      else
        format.html { render :edit }
        format.json { render json: @plant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plants/1
  # DELETE /plants/1.json
  def destroy
    @plant.active = false
    @plant.save

    respond_to do |format|
      format.html { redirect_to company_path, notice: 'Plant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_plant
    @plant = Plant.find(params[:id])
  end

  def set_company
    @company = Company.find(params[:company_id])
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
      :active, :name, :code, :company_id, :address01, :address02,
      :state, :zip, :phone, :flow_design, :lab_number_per_cycle,
      :internal_number_per_cycle, :startup_date, :country_id,
      :discharge_point_id
    )
  end
end
