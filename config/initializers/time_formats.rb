Time::DATE_FORMATS[:custom_datetime] = ->(time) { time.strftime("%B #{time.day.ordinalize}") }

Date::DATE_FORMATS[:custom] = ->(time) { time.strftime("%B #{time.day.ordinalize}, %Y") }
