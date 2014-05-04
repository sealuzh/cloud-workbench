require 'pathname'
class VagrantDriver
  attr_reader :vagrantfile_path, :vagrant_dir_path
  CURRENT_DIR = '.'
  PARENT_DIR = '..'

  def initialize(vagrantfile_path, log_dir)
    @vagrantfile_path = vagrantfile_path
    @vagrant_dir_path = File.dirname(vagrantfile_path)
    @log_dir = log_dir
  end

  # Returns an array of hashes
  # Example: [ { provider_name: 'aws', provider_instance_id: 'i-cn539k8x' }, ... ]
  def detect_vm_instances
    virtual_machines = []
    Pathname(machines_dir).each_child do |machine|
      base = machine.basename.to_s
      if machine.directory? && base != CURRENT_DIR && base != PARENT_DIR
        virtual_machines.concat(detect_vms_with_role(base))
      end
    end
  end

  # TODO: refactor, simplify
  def detect_vms_with_role(role)
    virtual_machines = []
    Rails.application.config.supported_providers.each do |provider|
      provider_id_file = File.join(machines_dir, role, provider, 'id')
      if File.exist?(provider_id_file)
        provider_id = File.read(provider_id_file)
        virtual_machines.push({ provider_name: provider,
                                provider_instance_id: provider_id
                              })
      end
      virtual_machines
    end
  end

  def up(provider)
    %x( cd "#{@vagrant_dir_path}" &&
        vagrant up --provider=#{provider} >> #{up_log_file} 2>&1 )
    $?.success?
  end

  def destroy
    %x( cd "#{@vagrant_dir_path}" &&
        vagrant destroy --force >>#{destroy_log_file} 2>&1 )
    $?.success?
  end

  def up_log
    File.read(up_log_file)
  end

  def destroy_log
    File.read(destroy_log_file)
  end

  def up_log_file
    File.join(@log_dir, 'vagrant_up.log')
  end

  def destroy_log_file
    File.join(@log_dir, 'vagrant_destroy.log')
  end

  private

    def machines_dir
      File.join(@vagrant_dir_path, '.vagrant', 'machines')
    end
end