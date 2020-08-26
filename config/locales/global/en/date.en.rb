{
  en: {
    date: {
      formats: {
        default: "%m/%d/%Y",                                         # 06/25/2015
        day_month: "%m/%d",                                          # 06/25
        long: lambda { |date, _| "%B #{date.day.ordinalize}, %Y" },  # June 25, 2015
        short: lambda { |date, _| "%B #{date.day.ordinalize}" },     # Jun 25
        params: "%Y-%m-%d"                                           # 2015-06-25
      }
    }
  }
}
