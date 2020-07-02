class LogbooksController < ApplicationController
  before_action :set_date, only: %i[create new edit update show]
  load_and_authorize_resource

  # GET /logbooks
  # GET /logbooks.json
  def index
    @logbooks = @plant.logbooks.active
  end

  # GET /logbooks/1
  # GET /logbooks/1.json
  def show
    @plant = Plant.find(params[:plant_id])
    @logbook = @plant.logbooks.find(params[:id])
    @filtered_logs = @logbook.logs.includes(:task).order('date DESC')

  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: t(:access_not_allowed, scope: :global)
  end

  # GET /logbooks/1/edit
  def edit
    @plant = Plant.find(params[:plant_id])
    @logbook = @plant.logbooks.find(params[:id])

    lgs = Processing::Logbook.get_logs_from(@logbook, current_user)
    @filtered_logs = lgs.sort_by(&:date).reverse

  rescue ActiveRecord::RecordNotFound => _e
    redirect_to pages_no_permission_path, notice: t(:access_not_allowed, scope: :global)
  end

  # PATCH/PUT /logbooks/1
  # PATCH/PUT /logbooks/1.json
  def update
    @logbook.logs = @logbook.logs.map do |log|
      log.value = '' if (log.value == '0' || log.value.nil?) && log.task.checkbox?
      log
    end

    respond_to do |format|
      if @logbook.update(logbook_params)
        format.html { redirect_to edit_plant_logbook_path(@plant, @logbook), notice: 'Logbook was successfully updated.' }
        format.json { render :show, status: :ok, location: @logbook }
      else
        format.html { render :edit }
        format.json { render json: @logbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logbooks/1
  # DELETE /logbooks/1.json
  def destroy
    @logbook.logs.update_all(active: false)
    @logbook.inactive!
    respond_to do |format|
      format.html { redirect_to plant_logbooks_path(@logbook.plant), notice: 'Logbook was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def current_logs(logs, date)
    logs.select { |log| log.date == date }
  end

  def previous_logs(logs, date)
    logs.select { |log| log.date < date && log.value.blank? }
  end

  def check_date
    @current_date
  end

  def set_date
    @current_date = Date.today
  end

  def logbook_params
    params.require(:logbook).permit(:id, :plant_id, logs_attributes: %i[id logbook_id active value document date])
  end
end
