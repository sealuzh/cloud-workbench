require 'yaml'
require 'base64'

class CwbConfig
  NOT_PROVIDED = 'NOT PROVIDED'
  SECRETS_NOT_APPLIED = 'SECRETS NOT APPLIED'

  def initialize(opts)
    @config_dir = opts[:config_dir]
    @apply_secrets = opts[:apply_secrets]
    @ssh_username = opts[:ssh_username]
  end

  def chef_config
    config = load_yaml_config('config.yml.secret')
    build_json(config)
  end

  private

    def string_from_file(name)
      if @apply_secrets
        path = "#{@config_dir}/#{name}"
        File.read(path)
      else
        SECRETS_NOT_APPLIED
      end
    rescue => e
      puts "WARNING: Config file at #{path} does not exist. #{e.message}"
      NOT_PROVIDED
    end

    def base64_from_file(name)
      if @apply_secrets
        google_api_key = string_from_file(name)
        if google_api_key != NOT_PROVIDED
          Base64.encode64(google_api_key)
        else
          NOT_PROVIDED
        end
      else
        SECRETS_NOT_APPLIED
      end
    end

    def string_from_config(config, *args)
      if @apply_secrets
        result = config
        # Narrow down result
        args.each do |arg_item|
          result = result[arg_item]
        end
        fail "Config #{args.join(', ')} not present" if result.empty?
        result
      else
        SECRETS_NOT_APPLIED
      end
    rescue => e
      puts "WARNING: #{e.message}"
      NOT_PROVIDED
    end

    def load_yaml_config(name)
      path = "#{@config_dir}/#{name}"
      YAML.load_file(path)
    rescue => e
      puts "WARINING: No config file found in #{path}. #{e.message}"
      'CONFIG FILE NOT FOUND'
    end

    # Default CWB-Server Chef configuration
    def build_json(config)
      {
          'cloud-benchmarking-server' => {
              'apply_secret_config' => @apply_secrets,
              'chef' => {
                  'server_ip'       => config['chef']['server_ip'],
                  'node_name'       => 'cloud-benchmarking',
                  'client_key_name' => 'cloud-benchmarking',
                  'client_key'      => string_from_file('chef_client_key.pem'),
                  'validator_key'   => string_from_file('chef_validator.pem'),
              },
              'aws' => {
                  'ssh_key_name' => 'cloud-benchmarking',
                  'ssh_key'      => string_from_file('cloud-benchmarking.pem'),
                  'access_key'   => string_from_config(config, 'aws', 'access_key'),
                  'secret_key'   => string_from_config(config, 'aws', 'secret_key'),
              },
              'google' => {
                  'project_id' => string_from_config(config, 'google', 'project_id'),
                  'client_email' => string_from_config(config, 'google', 'client_email'),
                  'api_key' => base64_from_file('google-compute.p12')
              },
              'delayed_job' => {
                  'worker_processes' => '2'
              },
          },
          # For a list of time zones see: http://en.wikipedia.org/wiki/List_of_tz_database_time_zones
          'tz' => 'Europe/Zurich',
          'appbox' => {
              'deploy_keys' => config['cwb_server']['deploy_keys'],
              # Use first deploy key as admin key
              'admin_keys' => config['cwb_server']['deploy_keys'][1]
          },
          # TODO: Hide this detail in cwb-server cookbook
          'cbench-rackbox' => {
              'add_group_sudoers' => [ @ssh_username ]
          },
          # 'rackbox' => {
          #     'default_config' => {
          #         'unicorn' => {
          #             'worker_processes' => '2',
          #         }
          #     }
          # },
          'postgresql' => {
              # 'config' => {
              #     'max_connections' => '17'
              # },
              'config_pgtune' => {
                  'db_type' => 'desktop'
              }
          },
          'databox' => {
              'db_root_password' => config['cwb_server']['db_root_password'],
              'databases' => {
                  'postgresql' => [
                      { 'username' => 'cloud',
                        'password' => config['cwb_server']['db_password'],
                        'database_name' => 'cloud_benchmarking_production' }
                  ]
              }
          }
      }
    end
end
