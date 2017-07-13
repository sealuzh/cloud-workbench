module ShellRunner
  # Runs a shell command. Sanitizes Rails-related environment variables.
  #
  # @param cmd [String] shell command to execute
  # @param opts [Hash] options hash
  #   dir: directory wherein the command is executed
  #   log: file path for logging stdout and stderr
  # @return [Boolean] `true` if successful (i.e,. exit 0), `false` otherwise
  def shell(cmd, opts)
    full_cmd = ''
    full_cmd << "cd #{opts[:dir]} && " if opts[:dir]
    full_cmd << reset_env
    full_cmd << cmd
    full_cmd << shell_log(opts[:log]) if opts[:log]
    system(full_cmd)
    $?.success?
  end

  # Within the production environment, it could be the case the environment variables pollute
  # the process and cause vagrant commands to fail
  # Other variables are: `GEM_HOME='' BUNDLE_GEMFILE='' RUBYLIB='' BUNDLER_VERSION='' BUNDLE_BIN_PATH=''`
  def reset_env
    "RUBYLIB='' "
  end

  def shell_log(file)
    " >>#{file} 2>&1"
  end
end
