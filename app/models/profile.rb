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

  def self.edge_pack_url(user)
    user.profiles.where(active: true).first.edge_pack_url
  end

  def self.edge_pack_id(user)
    user.profiles.where(active: true).first.edge_pack_id
  end

  def self.edge_pack_pwd(user)
    user.profiles.where(active: true).first.edge_pack_pwd
  end

  def self.ws_user_id(user)
    user.profiles.where(active: true).first.ws_user_id
  end

  def self.ws_user_pwd(user)
    user.profiles.where(active: true).first.ws_user_pwd
  end

  def self.report_user(user)
    user.profiles.where(active: true).first.report_user
  end

  def self.cust_acct(user)
    user.profiles.where(active: true).first.cust_acct
  end

  def self.id(user)
    user.profiles.where(active: true).first.id
  end

  def self.server_name(user)
    user.profiles.where(active: true).first.server
  end

  def self.shipment_match_reference(user)
    user.profiles.where(active: true).first.shipment_match_reference
  end

  def self.so_match_reference(user)
    user.profiles.where(active: true).first.so_match_reference
  end
end
