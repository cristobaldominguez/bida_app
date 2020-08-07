class ExportsController < ApplicationController

  def index; end

  def logbook
    @logbook = Logbook.find(params[:id])
    @logs = Log.where(logbook_id: @logbook.id).sort_by(&:task_id).group_by(&:task_id)

    plant_number = @logbook.plant.id < 10 ? "0#{@logbook.plant.id}" : @logbook.plant.id

    file_name = "#{plant_number}.- Logbook #{@logbook.plant.name} #{@logbook.created_at.strftime('%Y-%m')}"

    respond_to do |format|
      format.xlsx { response.headers[ 'Content-Disposition' ] = "attachment; filename=#{file_name}.xlsx" }
    end
  end
end
