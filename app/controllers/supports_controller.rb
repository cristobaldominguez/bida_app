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
  def show
    @support.work_summaries = @support.work_summaries.select(&:active)
  end

  # GET /plants/1/supports/new
  def new
    @plant = Plant.find(params[:plant_id])
    @support = @plant.supports.build
    @attentions = @plant.users
    @support.work_summaries.build
  end

  # POST /plants/1/supports
  # POST /plants/1/supports.json
  def create
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
  def edit
    @support.work_summaries = @support.work_summaries.select(&:active)
    @work_summary = @support.work_summaries.build if @support.work_summaries.empty?
  end

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

  # GET /plants/1/supports/custom.js
  def custom
    respond_to do |format|
      format.js
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
    params.require(:support).permit(:active, :number, :start_date, :end_date,
      :client_onsite, :client_id, :bf_technician_id, work_summaries_attributes: [:description, :hours, :materials, :id, :_destroy, :active])
  end
end
