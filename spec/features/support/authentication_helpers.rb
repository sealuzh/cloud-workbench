# frozen_string_literal: true

include Warden::Test::Helpers
Warden.test_mode!

module AuthenticationHelpers
  # Does not work with let or given blocks
  def create_signed_in_user
    user = create(:user)
    sign_in(user)
    user
  end

  def sign_in(user)
    login_as user, scope: :user
  end

  def sign_out(user)
    logout(user)
  end

  def auth_reset
    Warden.test_reset!
  end
end