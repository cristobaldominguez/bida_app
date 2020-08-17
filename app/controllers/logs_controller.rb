class LogsController < ApplicationController
  load_and_authorize_resource

  def update
    respond_to do |format|
      if @log.update(alert_params)
        format.html { redirect_to @log, notice: 'Log was successfully updated.' }
        format.json { render json: @log.id, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  def self.generate_monthly_logs(logbook)
    @logbook = logbook
    task_dates = Processing::TaskDatesCreation.new(@logbook).get_dates
    current_time = @logbook.created_at.beginning_of_month
    @unsaved_logs = task_dates.keys.map { |key| task_dates[key].map { |date| "(#{key}, #{@logbook.id}, '#{date}', '#{current_time}', '#{current_time}')" }}.flatten

    insert_logs_into_db
  end

  private

  def self.insert_logs_into_db
    raw_sql = "INSERT INTO logs (task_id, logbook_id, date, created_at, updated_at) VALUES " + @unsaved_logs.join(', ')
    ActiveRecord::Base.connection.execute raw_sql
  end

  def alert_params
    params.require(:log).permit(:id, :task_id, :logbook_id, :active, :value, :date, :document)
  end
end
