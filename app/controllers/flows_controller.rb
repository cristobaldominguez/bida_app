class FlowsController < ApplicationController
  before_action :set_flow, only: [:show, :edit, :update, :destroy]

  # GET plants/:plant_id/flows
  # GET plants/:plant_id/flows.json
  def index
    @flows = Flow.all
  end

  # GET plants/:plant_id/flows/1
  # GET plants/:plant_id/flows/1.json
  def show; end

  # GET plants/:plant_id/flows/new
  def new
    @flow = Flow.new
  end

  # GET plants/:plant_id/flows/1/edit
  def edit; end

  # POST plants/:plant_id/flows
  # POST plants/:plant_id/flows.json
  def create
    @flow = Flow.new(flow_params)

    respond_to do |format|
      if @flow.save
        format.html { redirect_to @flow, notice: 'Flow was successfully created.' }
        format.json { render :show, status: :created, location: @flow }
      else
        format.html { render :new }
        format.json { render json: @flow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT plants/:plant_id/flows/1
  # PATCH/PUT plants/:plant_id/flows/1.json
  def update
    respond_to do |format|
      if @flow.update(flow_params)
        format.html { redirect_to @flow, notice: 'Flow was successfully updated.' }
        format.json { render :show, status: :ok, location: @flow }
      else
        format.html { render :edit }
        format.json { render json: @flow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE plants/:plant_id/flows/1
  # DELETE plants/:plant_id/flows/1.json
  def destroy
    @flow.active = false
    @flow.save
    respond_to do |format|
      format.html { redirect_to flows_url, notice: 'Flow was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_flow
    @flow = Flow.find(params[:id])
  end

  def flow_params
    params.require(:flow).permit(:value, :plant_id, :active)
  end
end
