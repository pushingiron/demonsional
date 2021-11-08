class CreateSoJob < ApplicationJob
  queue_as :so

  #around_perform

  #after_perform

  def perform(cust_acct, current_user, pickup_date, enterprise)

    Path.create(description: "Starting to creating SO's in #{cust_acct}", object: 'Job', action: 'begin', user_id: current_user.id)
    @shipping_orders = current_user.shipping_orders.all
    @shipping_orders.each do |so|
      so.cust_acct_num = cust_acct
    end
    @response = ShippingOrder.mg_post(@shipping_orders, current_user.so_match_reference,
                                      current_user.shipment_match_reference, current_user)
    Path.create(description: "Finish creating SO's in #{enterprise}", object: 'Job', action: 'end', user_id: current_user.id)
    Path.create(description: "Create MMO job for #{enterprise}", object: 'Job', action: 'schedule', user_id: current_user.id)
    MmoJob.set(wait: 2.minutes).perform_later(current_user, enterprise, enterprise) unless enterprise.include? 'Planning'
  end

end
