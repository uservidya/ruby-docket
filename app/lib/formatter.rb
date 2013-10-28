module Formatter

  DATE_FORMAT='%Y-%m-%d'

  def self.format_date(date)
    date.try(:strftime, DATE_FORMAT) || '(null)'
  end

  def self.format_time(time)
    time.to_formatted_s(:long)
  end

  def self.format_percent(pct)
    unless pct.nil?
      "#{(pct*100.0).round(2)}%"
    else
      '0.0%'
    end
  end
end
