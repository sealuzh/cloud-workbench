# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :recoverable, :validatable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :timeoutable
end
