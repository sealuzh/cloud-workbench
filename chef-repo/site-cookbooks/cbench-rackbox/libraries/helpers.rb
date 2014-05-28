module Rackbox
  module Helpers
    def setup_unicorn_runit(app, app_dir)
      config = merge_runit_config(
        node["rackbox"]["default_config"]["unicorn_runit"],
        app["runit_config"]
        )
      unicorn_config_file = unicorn_config_filepath(app["appname"])

      runit_service app["appname"] do
        run_template_name  config["template_name"]
        log_template_name  config["template_name"]
        cookbook           config["template_cookbook"]
        options(
          :user                 => node["appbox"]["apps_user"],
          :group                => node["appbox"]["apps_user"],
          :rack_env             => config["rack_env"],
          :smells_like_rack     => true, #::File.exists?(::File.join(app_dir, "config.ru")),
          :unicorn_config_file  => unicorn_config_file,
          :working_directory    => app_dir,
          :app_name             => app["appname"]
          )
        # The BUNDLE_GEMFILE environment variable is required if running rails apps with unicorn.
        # Otherwise unicorn would fail on startup with a 'Bundler::GemfileNotFound' exception searching
        # within another directory for the Gemfile (e.g. searching in 'shared/Gemfile')
        # See: http://blog.willj.net/2011/08/02/fixing-the-gemfile-not-found-bundlergemfilenotfound-error/
        env(
          'BUNDLE_GEMFILE'      => File.join(app_dir, 'Gemfile'),
          'BUNDLE_PATH'         => File.absolute_path(File.join(app_dir, '../shared/vendor/bundle')), # Symlinked to shared/vendor/bundle
          'EXECJS_RUNTIME'      => 'Node'
        )
        restart_on_update false
      end
    end
  end
end