class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # Removed defaults: :registerable, :recoverable, :validatable
  devise :database_authenticatable, :rememberable, :trackable
end
