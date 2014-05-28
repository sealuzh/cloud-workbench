class IOBench

  def prepare_benchmark(file_size)
    system("sysbench --test=fileio --file-total-size=#{file_size} prepare")
  end

  def run_benchmark(file_size, max_time)
    ioResultAsString = `sysbench --test=fileio --file-total-size=#{file_size} --file-test-mode=rndrw --init-rng=on --max-time=#{max_time} --max-requests=0 run`
    (find_io_result_in_string ioResultAsString)[1]
  end

  def find_cpu_info
    `cat /proc/cpuinfo | grep 'model name' | cut -d ':' -f 2`
  end

  def now
    `date`
  end

  def find_io_result_in_string(string)
    /\((.*sec.*)\)/.match string
  end

end