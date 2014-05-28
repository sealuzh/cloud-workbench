class CompileBenchmark

  def do_benchmark(download_cmd, compile_cmd)
    t1 = Time.now
    success = download_sources download_cmd
    if !success
      "Downloading sources failed with command #{download_cmd}"
    else
      success = compile_sources compile_cmd
      if !success
        "Compiling sources failed with command #{compile_cmd}"
      else
        t2 = Time.now
        t2 - t1
      end
    end
  end

  def do_cleanup(cleanup_cmd)
    system(cleanup_cmd)
  end

  def download_sources(download_cmd)
    system(download_cmd)
  end

  def compile_sources(compile_cmd)
    system(compile_cmd)
  end

  def find_cpu_info
    `cat /proc/cpuinfo | grep 'model name' | cut -d ':' -f 2`
  end

  def now
    `date`
  end

end