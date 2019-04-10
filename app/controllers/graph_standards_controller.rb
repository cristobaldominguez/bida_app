class GraphStandardsController < ApplicationController
  before_action :set_graph_standard, only: [:show, :edit, :update, :destroy]

  # GET /plants/:plant_id/graph_standards
  # GET /plants/:plant_id/graph_standards.json
  def index
    @graph_standards = @plant.graph_standards.includes(:chart)
  end

  # GET /plants/:plant_id/graph_standards/1
  # GET /plants/:plant_id/graph_standards/1.json
  def show; end

  # GET /graph_standards/new
  def new
    @graph_standard = @plant.graph_standards.new
  end

  # GET /graph_standards/1/edit
  def edit; end

  # POST /plants/:plant_id/graph_standards
  # POST /plants/:plant_id/graph_standards.json
  def create
    @graph_standard = GraphStandard.new(graph_standard_params)

    respond_to do |format|
      if @graph_standard.save
        format.html { redirect_to @graph_standard, notice: 'Graph standard was successfully created.' }
        format.json { render :show, status: :created, location: @graph_standard }
      else
        format.html { render :new }
        format.json { render json: @graph_standard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plants/:plant_id/graph_standards/1
  # PATCH/PUT /plants/:plant_id/graph_standards/1.json
  def update
    respond_to do |format|
      if @graph_standard.update(graph_standard_params)
        format.html { redirect_to @graph_standard, notice: 'Graph standard was successfully updated.' }
        format.json { render :show, status: :ok, location: @graph_standard }
      else
        format.html { render :edit }
        format.json { render json: @graph_standard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plants/:plant_id/graph_standards/1
  # DELETE /plants/:plant_id/graph_standards/1.json
  def destroy
    @graph_standard.inactive!
    respond_to do |format|
      format.html { redirect_to graph_standards_url, notice: 'Graph standard was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_graph_standard
    @graph_standard = GraphStandard.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def graph_standard_params
    params.require(:graph_standard).permit(:plant_id, :chart_id, :active, :show)
  end
end
