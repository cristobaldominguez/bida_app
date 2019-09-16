class Day
  def initialize(day)
    @day = day
  end

  def fullname
    return "#{@day}day" if %w[mon fri sun].include?(@day)
    return 'tuesday' if @day == 'tue'
    return 'wednesday' if @day == 'wed'
    return 'thursday' if @day == 'thu'
    return 'saturday' if @day == 'sat'
  end

  def day_in_words
    case @day
    when 1 then 'first'
    when 2 then 'second'
    when 3 then 'third'
    when 4 then 'fourth'
    end
  end
end
