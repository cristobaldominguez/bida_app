class ImportsController < ApplicationController
  def new; end

  def create; end

  def flows
    @flow_import = FlowImport.new
  end

  def flows_create
    fp = updated_params(params, :flow_import)
    @flow_import = FlowImport.new(fp)
    @flow_import.save

    if @flow_import.save
      redirect_to plant_flow_reports_path(params[:plant_id])
    else
      render :new
    end
  end

  def updated_params(params, target)
    current_params = params[target]
    current_params[:plant] = params[:plant_id].to_i
    current_params
  end

  def import_params
    params.require(:import).permit(:file)
  end
end
