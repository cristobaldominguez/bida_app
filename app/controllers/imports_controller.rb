class ImportsController < ApplicationController
  def new; end

  def create; end

  def flows
    @flow_import = FlowImport.new
  end

  def flow_params(params)
    import_params = params[:flow_import]
    current_flow_params = import_params.except('date(1i)', 'date(2i)', 'date(3i)')
    current_flow_params[:date] = Date.civil(import_params['date(1i)'].to_i, import_params['date(2i)'].to_i, import_params['date(3i)'].to_i)
    current_flow_params[:plant] = params[:plant_id].to_i
    current_flow_params
  end

  def flows_create
    fp = flow_params(params)
    @flow_import = FlowImport.new(fp)
    @flow_import.save

    if @flow_import.save
      redirect_to plant_flow_reports_path(params[:plant_id])
    else
      render :new
    end
  end

  def import_params
    params.require(:import).permit(:file, :date)
  end
end
