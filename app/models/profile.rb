class Profile < ApplicationRecord
  belongs_to :user

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
                 :server,
                 :call_check_report,
                 :delivered_report,
                 :in_transit_report,
                 :tender_accept_report,
                 :tender_reject_report,
                 :need_invoice_report

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
    begin
      user.profiles.where(active: true).first.cust_acct
    rescue
      'unknown'
    end
  end

  def self.id(user)
    begin
      user.profiles.where(active: true).first.id
    rescue
      'unknown'
    end
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

  def self.tender_accept_report(user)
    user.profiles.where(active: true).first.tender_accept_report
  end

  def self.tender_reject_report(user)
    user.profiles.where(active: true).first.tender_reject_report
  end

  def self.in_transit_report(user)
    user.profiles.where(active: true).first.in_transit_report
  end

  def self.delivered_report(user)
    user.profiles.where(active: true).first.delivered_report
  end

  def self.call_check_report(user)
    user.profiles.where(active: true).first.call_check_report
  end

  def self.invoice_report(user)
    user.profiles.where(active: true).first.need_invoice_report
  end
end
