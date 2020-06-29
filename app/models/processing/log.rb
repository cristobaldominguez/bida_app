require 'json'

class Processing::Log
  def initialize(log, current_date = Date.today)
    @log = log
    @current_date = current_date
    @task = @log.task
    @cycle = JSON.parse(@task.cycle) if @task.cycle.present?
    @current_day = @current_date.strftime('%a').downcase
    @plant = @task.task_list.plant
  end

  def valid?(current_user)
    return false if plant_in_season?
    return false unless employee_can_execute?(current_user)

    frecuency_validate?
  end

  def generate?
    return false if plant_in_season?

    frecuency_validate?
  end

  def add_new?
    @log.date == @current_date
  end

  private

  def employee_can_execute?(current_user)
    current_task = @task.responsible.zero? # Si responsible == 0, la empresa se hace responsable
    current_task && current_user.company? || !current_task && current_user.biofiltro?
  end

  def frecuency_validate?
    return true if @task.daily?
    return weekly_validate? if @task.weekly?
    return every_2_weeks_validate? if @task.every_2_weeks?
    return monthly_validate? if @task.monthly?
    return every_x_months_validate? if @task.every_x_months?
  end

  def weekly_validate?
    @cycle['days'].select { |day| day['day'] == @current_day }.any?
  end

  def every_2_weeks_validate?
    cycles = @cycle['days'].group_by { |day| day['week'] } # Divide los ciclos por semanas pares o impares
    cycle_num = define_cycle_week(cycles)
    return false if cycle_num.nil?

    cycles[cycle_num].select { |day| day['day'] == @current_day }.any?
  end

  def monthly_validate?
    @cycle['days'].map { |day| current_day?(day) }.include? true
  end

  def every_x_months_validate?
    return false unless month_present?

    monthly_validate?
  end

  def plant_in_season?
    @plant.high_season && @task.out_season? || !@plant.high_season && @task.in_season?
  end

  def even_week?
    @current_date.strftime('%W').to_i.even? || false
  end

  def odd_week?
    @current_date.strftime('%W').to_i.odd? || false
  end

  def current_day?(day)
    return false if day['week'] > @current_date.week_of_month

    day_pos = day_position_in_week(day['day'])
    date = day_date_number(day_pos)
    return false unless date

    log_date = Date.new(@current_date.year, @current_date.month, date)
    log_date == @current_date
  end

  def define_cycle_week(cycles)
    cycle_num = odd_week? && cycles[1] ? 1 : nil      # Setea la variable cycle_num con el numero del ciclo de la semana 1
    even_week? && cycles[2] ? 2 : cycle_num           # Si en la variable anterior no se definio el valor, setea la variable con el numero 2
  end

  def day_position_in_week(day)
    week = %w[mon tue wed thu fri sat sun]
    week.index(day)
  end

  def day_date_number(day_pos)
    weeks_of_month = @current_date.week_split
    this_week = @current_date.week_of_month - 1
    next_week = @current_date.week_of_month

    check_day(weeks_of_month[this_week], weeks_of_month[next_week], day_pos)
  end

  def check_day(this_week, next_week, day_pos)
    doit_this_week = this_week[day_pos]

    return doit_this_week if doit_this_week.present?

    has_day_next_week = next_week.present? && next_week[day_pos].present?
    has_day_next_week ? next_week[day_pos] : false
  end

  def month_present?
    @cycle['months'].select { |month| month['month'] == @current_date.month }.present?
  end
end
