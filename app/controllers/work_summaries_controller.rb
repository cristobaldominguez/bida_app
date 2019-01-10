class WorkSummariesController < ApplicationController

  def destroy
    @work_summary = WorkSummary.find(params[:id])
    @work_summary.active = false
    @work_summary.save

    # @work_summary.update(active: false)
    # crear metodo de instancia en el modelo
    # @work_summary.inactive!
  end
end
