class CreateSoJob < ApplicationJob
  queue_as :so
  before_enqueue :before_q
  before_perform :before_p

  def perform(cust_acct, current_user, pickup_date, enterprise, level)
=begin
    p '*****Running the job to create SOs*****'
    file = File.join(Rails.root, 'app/assets', 'data', 'SO Automation.csv')
    current_user.shipping_orders.import(file)
=end
    @shipping_orders = current_user.shipping_orders.all
    @shipping_orders.each do |so|
=begin
      so.early_pickup_date = (Date.parse "#{pickup_date}") + 8.hours
      so.late_pickup_date = (Date.parse "#{pickup_date} 16:00:00.000000000") + 5.days + 16.hours
      so.early_delivery_date = (Date.parse "#{pickup_date} 08:00:00.000000000") + 1.days + 8.hours
      so.late_delivery_date = (Date.parse "#{pickup_date} 16:00:00.000000000") + 6.days + 16.hours
=end
      so.cust_acct_num = cust_acct
    end
    @response = ShippingOrder.mg_post(@shipping_orders, current_user.so_match_reference,
                                      current_user.shipment_match_reference)
    p '****MMO*****'
    p level
    MmoJob.set(wait: 1.minutes).perform_later(current_user, enterprise, level) unless %w[Admin Planning].include?(level)
  end

  private

  def before_q
    p 'SOJob before_q'
  end

  def before_p
    p 'SOJob before_p'
  end

end
