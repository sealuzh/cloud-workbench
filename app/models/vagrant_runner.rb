# frozen_string_literal: true

class VagrantRunner
  include ShellRunner
  attr_reader :vagrant_dir

  def initialize(vagrant_dir)
    @vagrant_dir = vagrant_dir
  end

  def start_benchmark
    ssh_command(Rails.application.config.vm_start_runner)
  end

  def start_postprocessing
    ssh_command(Rails.application.config.vm_start_postprocessing)
  end

  def ssh_command(executable)
    # NOTE: We cannot use && between cd and nohup because this doesn't work together with non-blocking commands
    start_cmd = "vagrant ssh -- \"cd '#{Rails.application.config.vm_benchmark_dir}';
    nohup './#{executable}' >/dev/null 2>>'#{Rails.application.config.vm_error_log_file}' </dev/null &\""
    shell(start_cmd, dir: @vagrant_dir)
  end
end
