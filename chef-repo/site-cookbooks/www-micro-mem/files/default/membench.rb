class MBW

  def run(framesize, repetitions)

    results ||= []
    repetitions.times do
      results << do_benchmark(framesize)
    end
    results.inject{ |sum, el| sum + el }.to_f / results.size

  end

  def do_benchmark(framesize)
    resultString = `mbw #{framesize} | grep 'AVG'`
    results = find_mem_results_in_string resultString
    sum = 0
    results.each{|el| sum += el[0].to_f}
    (sum / results.size).to_f
  end

  def find_cpu_info
    `cat /proc/cpuinfo | grep 'model name' | cut -d ':' -f 2`
  end

  def now
    `date`
  end

  def find_mem_results_in_string(string)
    string.scan(/Copy: (.*) MiB/)
  end

end