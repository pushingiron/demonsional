class User < ApplicationRecord

  has_many :enterprises, dependent: :destroy
  has_many :shipping_orders, dependent: :destroy
  has_many :configurations, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :paths, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_many :items, through: :shipping_orders
  has_many :item_references, through: :items


  serialize :preferences, HashSerializer



  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
