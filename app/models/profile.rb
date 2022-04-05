class Profile < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :active

  serialize :preferences, HashSerializer
  store_accessor :config, :cust_acct,
                 :so_match_reference,
                 :shipment_match_reference,
                 :edge_pack_url,
                 :edge_pack_id,
                 :edge_pack_pwd,
                 :ws_user_id,
                 :ws_user_pwd,
                 :report_user,
                 :server
end
