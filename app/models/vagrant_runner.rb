# frozen_string_literal: true

class VagrantRunner
  include ShellRunner
  attr_reader :vagrant_dir

  def initialize(vagrant_dir)
    @vagrant_dir = vagrant_dir
  end

  def start_benchmark
    ssh_exec(Rails.application.config.vm_start_runner)
  end

  def start_postprocessing
    ssh_exec(Rails.application.config.vm_start_postprocessing)
  end

  # Execute the given `executable` via SSH remotely
  def ssh_exec(executable, dir = Rails.application.config.vm_benchmark_dir, log = Rails.application.config.vm_error_log_file)
    shell_cmd = ssh_shell_cmd(executable, dir, log)
    shell(shell_cmd, dir: @vagrant_dir)
  end

  # Compose SSH shell command for triggering an `executable` remotely
  def ssh_shell_cmd(executable, dir, log)
    # NOTE: We cannot use && between cd and nohup because this doesn't work together with non-blocking commands
    "vagrant ssh -- \"cd '#{dir}';
    nohup './#{executable}' >/dev/null 2>>'#{log}' </dev/null &\""
  end
end
