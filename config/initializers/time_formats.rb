Time::DATE_FORMATS[:custom_datetime] = ->(time) { time.strftime("%B #{time.day.ordinalize}") }

Date::DATE_FORMATS[:english] = ->(date) { date.strftime("%B #{date.day.ordinalize}, %Y") }
# .to_s(:long_ordinal)
