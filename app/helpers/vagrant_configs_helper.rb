module VagrantConfigsHelper
  def base_file_error?(vagrant_config)
    vagrant_config.errors[:base_file].any?
  end

  def provider_docs(name, link, icon = 'github')
    link_to "vagrant-#{name}&nbsp;#{fa_icon(icon)}".html_safe, link, target: '_blank'
  end
end
