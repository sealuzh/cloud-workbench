# frozen_string_literal: true

# DateTime format docs: http://apidock.com/ruby/DateTime/strftime

# Example: 2014-06-29 11:35:41
Time::DATE_FORMATS[:date_and_time_long] = '%Y-%m-%d %H:%M:%S'
# Example: 2014-06-29 11:35
Time::DATE_FORMATS[:date_and_time_short] = '%Y-%m-%d %H:%M'
# Example: 2014-06-29
Time::DATE_FORMATS[:date_only] = '%Y-%m-%d'
# Example: 11:35
Time::DATE_FORMATS[:time_only] = '%H:%M'
# Example: June 2014
Time::DATE_FORMATS[:month_and_year] = '%B %Y'
# Example: 29. June 2014 (without leading zero: 7. June 2014)
Time::DATE_FORMATS[:date_human] = '%e. %B %Y'