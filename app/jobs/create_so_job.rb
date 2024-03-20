class CreateSoJob < ApplicationJob

  queue_as :so

  #around_perform

  #after_perform

  def perform(user)

    job_delay = 0.0
    @shipping_orders = user.shipping_orders.all
    Path.create(description: "Starting to creating SO's", object: 'Job', action: 'begin', user_id: user.id, data: MercuryGateXml.shipping_order_xml(user, @shipping_orders))
    @response = MercuryGateApiServices.mg_post_xml(user, MercuryGateXml.shipping_order_xml(user, @shipping_orders))
    Path.create(description: "Finish creating SO's in", object: 'Job', action: 'end', user_id: user.id, data: @response)
    Path.create(description: "Create MMO job for", object: 'Job', action: 'schedule', user_id: user.id)
    enterprise = user.enterprises.all
    enterprise.each do |e|
      unless (e.company_name.include? 'Admin') || (e.company_name.include? 'Planning')
        MmoJob.set(wait: job_delay.minutes).perform_later(user, e.company_name)
        job_delay += 1
      end
    end
  end

end
