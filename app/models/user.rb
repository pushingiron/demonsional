class User < ApplicationRecord

  has_many :enterprises, dependent: :destroy
  has_many :shipping_orders, dependent: :destroy
  has_many :configurations, dependent: :destroy

  serialize :preferences, HashSerializer
  store_accessor :config, :cust_acct, :so_match_reference, :shipment_match_reference


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
