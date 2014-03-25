json.array!(@virtual_machine_definitions) do |virtual_machine_definition|
  json.extract! virtual_machine_definition, :id, :role, :region, :instance_type, :image
  json.url virtual_machine_definition_url(virtual_machine_definition, format: :json)
end
