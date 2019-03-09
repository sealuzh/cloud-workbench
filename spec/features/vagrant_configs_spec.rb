# frozen_string_literal: true

require 'rails_helper'

feature 'Vagrant Configuration' do
  given(:user) { create(:user) }
  before { sign_in(user) }

  feature 'Show' do
    scenario 'Should show the base Vagrantfile' do
      visit edit_vagrant_config_path
      expect(page).to have_content(/Vagrant.configure/)
    end
  end

  feature 'Update' do
    let(:new_base_file) { 'new base Vagrantfile' }
    scenario 'Should update the base Vagrant' do
      visit edit_vagrant_config_path
      fill_in 'Base file', with: new_base_file
      click_button 'Update Vagrant Configuration'
      expect(page).to have_content(new_base_file)
    end
  end

  feature 'Reset defaults' do
    given(:new_file) { 'new base_file' }
    before { VagrantConfig.instance.update!(base_file: new_file) }
    scenario 'Should load the default base Vagrantfile from code' do
      visit edit_vagrant_config_path
      expect(page).to have_content(new_file)
      click_button 'Reset Defaults'
      expect(page).to_not have_content(new_file)
      expect(page).to have_content(/Vagrant.configure/)
    end
  end
end
