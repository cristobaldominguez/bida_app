require 'json'

class LogbookProcessor
  def initialize(logbook)
    @logs = logbook.logs.includes(task: [:task_list]).order('date DESC')
    @task_list = logbook.task_list
    @plant = logbook.plant
    @current_date = Date.today
    @prev_month = @current_date.beginning_of_month.prev_month
  end

  def valid_logs(current_user)
    list_valid_logs = @task_list.tasks.map do |task|
      @task = task
      date = generate_cycle_dates(task)
      next if date.nil?
      next if plant_in_season?(task)
      next unless employee_can_execute?(current_user)

      log_on_date(date, task)
    end

    list_valid_logs.flatten.reject(&:nil?)
  end

  def generate_cycle_dates(cls)
    return @current_date if cls.daily?
    return weekly_period if cls.weekly?
    return every_2_weeks_period if cls.every_2_weeks?
    return monthly_period if cls.monthly?
    return every_x_months_period if cls.every_x_months?
  end

  def log_on_date(date, task)
    @logs.select { |log| log.date == date && log.task_id == task.id }
  end

  def weekly_period
    cycle = JSON.parse(@task.cycle)
    weeks = last_two_weeks
    dates = array_of_dates(cycle['days'], weeks)

    dates.reject(&:nil?).empty? ? nil : closest_day(dates)
  end

  def every_2_weeks_period
    cycle = JSON.parse(@task.cycle)
    days = weeks_dates
    dates = array_of_dates(cycle['days'], days)

    dates.reject(&:nil?).empty? ? nil : closest_day(dates)
  end

  def monthly_period
    cycle = JSON.parse(@task.cycle)
    dates = cycle['days'].map { |day| [@prev_month.public_send(method_in_string(day)), @current_date.public_send(method_in_string(day))] }.flatten

    dates.reject(&:nil?).empty? ? nil : closest_day(dates)
  end

  def every_x_months_period
    cycle = JSON.parse(@task.cycle)
    months = months_in_period(cycle['months'])
    dates = cycle['days'].map { |day| months.map { |month| month.public_send(method_in_string(day)) } }.flatten

    dates.reject(&:nil?).empty? ? nil : closest_day(dates)
  end

  def closest_day(dates)
    dates.reject { |date| date > @current_date }.max
  end

  def even_week?
    @current_date.strftime('%W').to_i.even? || false
  end

  def odd_week?
    @current_date.strftime('%W').to_i.odd? || false
  end

  def last_two_weeks
    @current_date.prev_week.all_week.to_a + @current_date.all_week.to_a
  end

  def two_weeks_ago(date)
    date.prev_week.prev_week.all_week.to_a + date.all_week.to_a
  end

  def months_in_period(months)
    months.map { |month| [Date.new(@current_date.year, month['month'], 1) - 1.year, Date.new(@current_date.year, month['month'], 1)] }.flatten
  end

  def weeks_dates
    { even: even_week? ? two_weeks_ago(@current_date) : two_weeks_ago(@current_date - 1.week),
      odd: odd_week? ? two_weeks_ago(@current_date) : two_weeks_ago(@current_date - 1.week) }
  end

  def array_of_dates(days, dates)
    weeks = dates
    days.map do |day|
      if dates.is_a?(Hash)
        weeks = day['week'].even? ? dates[:even] : dates[:odd]
      end
      weeks.select { |week_day| week_day.public_send(Day.new(day['day']).fullname + '?') }
    end.flatten
  end

  def method_in_string(day)
    "#{Day.new(day['week']).day_in_words}_#{Day.new(day['day']).fullname}_in_month"
  end

  def plant_in_season?(cls)
    true if @plant.high_season && cls.out_season? || !@plant.high_season && cls.in_season?
  end

  def employee_can_execute?(current_user)
    return true if current_user.admin? # Todos los administradores podran ver todos los Logs

    current_task = @task.responsible.zero? # Si responsible == 0, la empresa se hace responsable
    current_task && current_user.company? || !current_task && current_user.biofiltro?
  end
end
