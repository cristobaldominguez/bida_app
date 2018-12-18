class BoundsController < ApplicationController
  before_action :set_bound, only: [:show, :edit, :update, :destroy]

  # GET /bounds
  # GET /bounds.json
  def index
    @bounds = Bound.all
  end

  # GET /bounds/1
  # GET /bounds/1.json
  def show
  end

  # GET /bounds/new
  def new
    @bound = Bound.new
  end

  # GET /bounds/1/edit
  def edit
  end

  # POST /bounds
  # POST /bounds.json
  def create
    @bound = Bound.new(bound_params)

    respond_to do |format|
      if @bound.save
        format.html { redirect_to @bound, notice: 'Bound was successfully created.' }
        format.json { render :show, status: :created, location: @bound }
      else
        format.html { render :new }
        format.json { render json: @bound.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bounds/1
  # PATCH/PUT /bounds/1.json
  def update
    respond_to do |format|
      if @bound.update(bound_params)
        format.html { redirect_to @bound, notice: 'Bound was successfully updated.' }
        format.json { render :show, status: :ok, location: @bound }
      else
        format.html { render :edit }
        format.json { render json: @bound.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bounds/1
  # DELETE /bounds/1.json
  def destroy
    @bound.active = false
    @bound.save
    respond_to do |format|
      format.html { redirect_to bounds_url, notice: 'Bound was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_bound
    @bound = Bound.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bound_params
    params.require(:bound).permit(:standard_id, :outlet_id, :from, :to)
  end
end
