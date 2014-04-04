class CloudProvider < ActiveRecord::Base
  has_many :virtual_machine_definitions
end
