# frozen_string_literal: true

require 'rails_helper'

describe VagrantDriver do
  let(:vagrant_driver) { build(:vagrant_driver) }
  let(:vm) { build(:virtual_machine_instance) }

  describe 'detect_vms_with_role' do
    before do
      @vms = vagrant_driver.detect_vms_with_role('default')
    end
    it 'should detect a single aws vm' do
      expect(@vms.size).to eq(1)
      expect(@vms[0]).to eq({ provider_name: vm.provider_name,
                              provider_instance_id: vm.provider_instance_id,
                              role: vm.role })
    end
  end

  describe 'detect_vm_instances' do
    before do
      @vms = vagrant_driver.detect_vm_instances
    end
    it 'should detect a single aws vm' do
      expect(@vms.size).to eq(1)
      expect(@vms[0]).to eq({ provider_name: vm.provider_name,
                              provider_instance_id: vm.provider_instance_id,
                              role: vm.role })
    end
  end
end
