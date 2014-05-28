### Utility methods
def detect_instance_id(instance_id_request)
  `#{instance_id_request}`
end

# Automatically detect the provider and instance id based on the cloud provider
def detect_and_configure_provider(providers)
  providers.each do |provider, provider_config|
    begin
      instance_id = detect_instance_id(provider_config["instance_id_request"])
      unless instance_id.empty?
        node.default["benchmark"]["provider_name"] = provider_config["name"]
        node.default["benchmark"]["provider_instance_id"] = instance_id
      end
    rescue => error
      log "Could not detect provider_instance_id for provider #{provider}. #{error.message}"
    end
  end
end

### Detect and set instance id for provider
providers = node["benchmark"]["providers"]
unless providers.nil?
  detect_and_configure_provider(providers)
end