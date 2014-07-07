class CPUBenchmark

  def run_benchmark(max_prime, threads)
    cpu_result_as_string = `sysbench --test=cpu --num-threads=#{threads} --cpu-max-prime=#{max_prime} run`
    (find_cpu_result_in_string cpu_result_as_string)[1]
  end

  def find_cpu_info
    `cat /proc/cpuinfo | grep 'model name' | cut -d ':' -f 2`
  end

  def now
    `date`
  end

  def find_cpu_result_in_string(string)
    /total time:\s*(.*)/.match string
  end

end