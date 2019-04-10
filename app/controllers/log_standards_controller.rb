class LogStandardsController < ApplicationController
  load_and_authorize_resource

  # GET /log_standards
  # GET /log_standards.json
  def index
    @log_standards = LogStandard.all
  end

  # GET /log_standards/1
  # GET /log_standards/1.json
  def show; end

  # GET /log_standards/new
  def new
    @log_standard = LogStandard.new
  end

  # GET /log_standards/1/edit
  def edit; end

  # POST /log_standards
  # POST /log_standards.json
  def create
    @log_standard = LogStandard.new(log_standard_params)

    respond_to do |format|
      if @log_standard.save
        format.html { redirect_to @log_standard, notice: 'Log standard was successfully created.' }
        format.json { render :show, status: :created, location: @log_standard }
      else
        format.html { render :new }
        format.json { render json: @log_standard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /log_standards/1
  # PATCH/PUT /log_standards/1.json
  def update
    respond_to do |format|
      if @log_standard.update(log_standard_params)
        format.html { redirect_to @log_standard, notice: 'Log standard was successfully updated.' }
        format.json { render :show, status: :ok, location: @log_standard }
      else
        format.html { render :edit }
        format.json { render json: @log_standard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /log_standards/1
  # DELETE /log_standards/1.json
  def destroy
    @log_standard.inactive!
    respond_to do |format|
      format.html { redirect_to log_standards_url, notice: 'Log standard was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def log_standard_params
    params.require(:log_standard).permit(:task_id, :frecuency_id, :plant_id, :active, :cycle, :responsible)
  end
end
