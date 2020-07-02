class LogsController < ApplicationController
  load_and_authorize_resource

  def self.generate_monthly_logs(logbook, current_date)
    @@logbook = logbook
    @@tasks = @@logbook.task_list.tasks
    days_of_month = current_date.week_split.flatten.reject(&:nil?)
    logs = days_of_month.map { |day| log_creation(Date.new(current_date.year, current_date.month, day)) }

    logs.flatten.map(&:save)
  end

  def self.log_creation(actual_date)
    generate_log(actual_date).reject(&:nil?)
  end

  def self.generate_log(actual_date)
    @@tasks.map do |task|
      log = Log.new(logbook: @@logbook, value: '', date: actual_date, task: task)
      Processing::Log.new(log, actual_date).generate? ? log : nil
    end
  end

  # Genera tasks a partir de un array de Tasks
  def self.generate_logs(current_date)
    days_of_month = current_date.week_split.flatten.reject(&:nil?)

    logs = days_of_month.map { |day| log_creation_from_task(Date.new(current_date.year, current_date.month, day)) }
    logs.flatten.map(&:save)
  end

  def self.log_creation_from_task(actual_date)
    new_logs = @@tasks.map do |task|
      log = generate_log(actual_date).reject(&:nil?)
    end
  end

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

  private

  def alert_params
    params.require(:log).permit(:id, :logbook_id, :active, :value, :document, :date)
  end
end
