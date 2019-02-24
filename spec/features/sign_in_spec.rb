# frozen_string_literal: true

require 'rails_helper'

feature 'Sign in' do
  given(:user) { create(:user, password: 'valid_pw') }
  before { user.save!; visit root_path }

  scenario 'with valid password' do
    expect(page).to have_field('password')

    fill_in 'password', with: user.password
    find('button[type="submit"]').click
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'with invalid password' do
    fill_in 'password', with: 'wrong_pw'
    find('button[type="submit"]').click
    expect(page).to have_content 'Invalid password.'
  end

  scenario 'with an invalid authentication token' do
    skip 'How to test this?'
    # Maybe like this: https://stackoverflow.com/a/34007085/6875981
  end
end
