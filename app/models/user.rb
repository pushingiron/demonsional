class User < ApplicationRecord

  has_many :enterprises
  has_many :shipping_orders
  has_many :configurations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
