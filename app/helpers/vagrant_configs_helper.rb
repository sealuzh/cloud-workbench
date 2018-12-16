module VagrantConfigsHelper
  def base_file_error?(vagrant_config)
    vagrant_config.errors[:base_file].any?
  end
end
