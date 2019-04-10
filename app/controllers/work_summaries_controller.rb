class WorkSummariesController < ApplicationController

  def destroy
    @work_summary = WorkSummary.find(params[:id])
    @work_summary.inactive!
  end
end
