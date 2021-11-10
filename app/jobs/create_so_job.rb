class CreateSoJob < ApplicationJob
  queue_as :so

  #around_perform

  #after_perform

  def perform(current_user)

    job_delay = 0.0

    Path.create(description: "Starting to creating SO's", object: 'Job', action: 'begin', user_id: current_user.id)
    @shipping_orders = current_user.shipping_orders.all
    @response = ShippingOrder.mg_post(@shipping_orders, current_user.so_match_reference,
                                      current_user.shipment_match_reference, current_user)
    Path.create(description: "Finish creating SO's in", object: 'Job', action: 'end', user_id: current_user.id)
    Path.create(description: "Create MMO job for", object: 'Job', action: 'schedule', user_id: current_user.id)
    enterprise = Enterprise.all
    enterprise.each do |e|
      unless (e.company_name.include? 'Admin') || (e.company_name.include? 'Planning')
        MmoJob.set(wait: job_delay.minutes).perform_later(current_user, e.company_name) unless e.company_name.include? 'Admin'
        job_delay += 1
      end
    end
  end

end
