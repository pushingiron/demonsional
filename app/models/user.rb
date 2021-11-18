class User < ApplicationRecord

  has_many :enterprises, dependent: :destroy
  has_many :shipping_orders, dependent: :destroy
  has_many :configurations, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :paths, dependent: :destroy

  serialize :preferences, HashSerializer
  store_accessor :config, :cust_acct,
                 :so_match_reference,
                 :shipment_match_reference,
                 :edge_pack_url,
                 :edge_pack_id,
                 :edge_pack_pwd,
                 :ws_user_id,
                 :ws_user_pwd,
                 :report_user


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
