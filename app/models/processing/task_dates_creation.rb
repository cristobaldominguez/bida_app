require 'json'

module Processing

  class TaskDatesCreation
    def initialize(logbook)
      @logbook = logbook
      @plant = @logbook.plant
      @tasks = @logbook.task_list.tasks
      @current_date = @logbook.created_at
      @date = { year: @current_date.year, month: @current_date.month }
      @first_week_of_month = @current_date.beginning_of_month.to_date.cweek
      weeks_divided_on_pairs = @current_date.week_split.partition.with_index { |_, i| i.even? }
      @odd_weeks = weeks_divided_on_pairs[@first_week_of_month.odd? ? 0 : 1]
      @even_weeks = weeks_divided_on_pairs[@first_week_of_month.even? ? 0 : 1]
      @cycle = {}
      @dates = {}
    end

    def get_dates
      @tasks.map do |task|
        @task = task
        @cycle = JSON.parse(task.cycle) if task.cycle.present?
        dts_arr = frecuency_dates

        _dates_arr = check_season(dts_arr)
        _dates_arr.present? && @dates[task.id] = _dates_arr
      end

      @dates
    end

    private

    def frecuency_dates
      return daily_dates if @task.daily?
      return weekly_dates if @task.weekly?
      return every_2_weeks_dates if @task.every_2_weeks?
      return monthly_dates if @task.monthly?
      return every_x_months_dates if @task.every_x_months?
    end

    def daily_dates
      Date.new(@date[:year], @date[:month], 1).days_array.reject(&:nil?).map { |day| Date.new(@date[:year], @date[:month], day).strftime('%Y-%m-%d') }
    end

    def weekly_dates
      _dates = @cycle['days'].map { |day| @current_date.week_split.map { |week| week[day['num'] - 1] } }.flatten.reject(&:nil?)
      _dates.map { |day| Date.new(@date[:year], @date[:month], day).strftime('%Y-%m-%d') }
    end

    def every_2_weeks_dates
      cycles = @cycle['days'].group_by { |day| day['week'] } # Divide los ciclos por semanas pares o impares
      return if cycles.blank?

      dates = cycles.map do |key, cycle|
        cycle.map do |day|
          _weeks = key.even? ? @even_weeks : @odd_weeks
          _current_dates = _weeks.map { |arr| arr[day['num'] % 7] }.reject(&:nil?)
          _current_dates.map {|date| Date.new(@date[:year], @date[:month], date).strftime('%Y-%m-%d') }
        end
      end

      dates.flatten.reject(&:nil?).sort
    end

    def monthly_dates
      method_from_days(@cycle['days'])
    end

    def every_x_months_dates
      months = @cycle['months'].select { |month| month['month'] == @date[:month] }.map { |month| Date.new(@date[:year], month['month'], 1) }
      months.map { |month| method_from_days(@cycle['days'], month) }.flatten
    end

    def check_season(dates_arr)
      return dates_arr if @task.no?                                 # Si el task no tiene temporadas

      methd = @task.in_season? ? 'between_high_season?' : 'between_low_season?'
      dates_arr.reject { |date| @plant.send(methd.to_sym, date) }
    end

    def method_from_days(days, current_date = nil)
      current_date ||= @current_date
      @cycle['days'].map do |day|
        mthd = "#{num_in_words(day['week'])}_#{complete_day_name(day['day'])}_in_month"
        current_date.send(mthd).strftime('%Y-%m-%d')
      end
    end

    def complete_day_name(day)
      days = { 'mon': 'monday', 'tue': 'tuesday', 'wed': 'wednesday', 'thu': 'thursday', 'fri': 'friday', 'sat': 'saturday', 'sun': 'sunday' }
      days[day.to_sym]
    end

    def num_in_words(num)
      numbers = ['', 'first', 'second', 'third', 'fourth']
      numbers[num]
    end
  end
end
