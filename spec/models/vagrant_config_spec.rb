require 'rails_helper'

describe VagrantConfig do
  let(:vagrant_config) { VagrantConfig.instance }

  it 'provides a default Vagrantfile base template' do
    expect(vagrant_config.base_file).to match(/Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|/)
  end

  describe 'Resetting' do
    let(:new_base_file) { 'new base_file' }
    let(:new_config) { VagrantConfig.instance.update!(base_file: new_base_file) }
    before { VagrantConfig.reset_defaults! }
    it 're-loads the default configuration from code' do
      expect(vagrant_config.base_file).to match(/Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|/)
    end
  end
end
