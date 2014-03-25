json.array!(@virtual_machine_instances) do |virtual_machine_instance|
  json.extract! virtual_machine_instance, :id, :status
  json.url virtual_machine_instance_url(virtual_machine_instance, format: :json)
end
