class SupportsController < ApplicationController
  before_action :set_create_assignment, only: :create
  before_action :set_support, only: [:show, :edit, :update, :destroy]

  # GET /supports
  # GET /supports.json
  def index
    @supports = Support.active
  end

  # GET /supports/1
  # GET /supports/1.json
  def show; end

  # GET /plants/1/supports/new
  def new
    @plant = Plant.find(params[:plant_id])
    @support = @plant.supports.build
    @attention = Plant.find(params[:plant_id]).users
  end

  # POST /plants/1/supports
  # POST /plants/1/supports.json
  def create
    @support.number = Support.all.size + 1000 + 1
    respond_to do |format|
      if @support.save
        format.html { redirect_to @support, notice: 'Support was successfully created.' }
        format.json { render :show, status: :created, location: @support }
      else
        format.html { render :new }
        format.json { render json: @support.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /supports/1/edit
  def edit; end

  # PATCH/PUT /plants/1/plants/1/supports/1
  # PATCH/PUT /plants/1/plants/1/supports/1.json
  def update
    respond_to do |format|
      if @support.update(support_params)
        format.html { redirect_to @support, notice: 'Support was successfully updated.' }
        format.json { render :show, status: :ok, location: @support }
      else
        format.html { render :edit }
        format.json { render json: @support.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supports/1
  # DELETE /supports/1.json
  def destroy
    @support.active = false
    @support.save

    respond_to do |format|
      format.html { redirect_to plant_path(@support.plant), notice: 'Support was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_support
    @support = Support.find(params[:id])
  end

  def set_create_assignment
    @support = Support.new(support_params)
    @support.plant = Plant.find(params[:plant_id])
    @support.user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def support_params
    params.require(:support).permit(:active, :number, :start_date, :end_date, :client_onsite, :name_client_onsite)
  end
end
