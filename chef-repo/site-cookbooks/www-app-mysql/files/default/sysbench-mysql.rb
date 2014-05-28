class MySQL

  def prepare_mysql_benchmark(username, pw, db, table_size)

    system("sysbench --test=oltp --oltp-table-size=#{table_size} --mysql-db=#{db} --mysql-user=#{username} --mysql-password=#{pw} prepare")

  end

  def run_mysql_benchmark(username, pw, db, table_size, max_time)

    result = `sysbench --test=oltp --oltp-table-size=#{table_size} --max-time=#{max_time} --oltp-test-mode=complex --oltp-read-only=off --num-threads=6 --max-requests=0 --mysql-db=#{db} --mysql-user=#{username} --mysql-password=#{pw} run`
    (find_mysql_result_in_string result)[1]

  end

  def find_cpu_info
    `cat /proc/cpuinfo | grep 'model name' | cut -d ':' -f 2`
  end

  def now
    `date`
  end

  def find_mysql_result_in_string(string)
    /transactions:.*\((.*)\)/.match string
  end

end