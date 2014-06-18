require 'csv'

class FioLogParser
  def self.parse_log(log_file, results_file = 'fio_results.csv')
    CSV.open(results_file, 'wb') do |csv|
      CSV.foreach(log_file) do |row|
        csv << [row[0], row[1].strip]
      end
    end
  end
end