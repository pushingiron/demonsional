class CreateSoJob < ApplicationJob

  include MercuryGateService

  queue_as :so

  #around_perform

  #after_perform

  def perform(user)

    job_delay = 0.0

    Path.create(description: "Starting to creating SO's", object: 'Job', action: 'begin', user_id: user.id)
    @shipping_orders = user.shipping_orders.all
    @response = mg_post_xml(user, shipping_order_xml(user, @shipping_orders))
    Path.create(description: "Finish creating SO's in", object: 'Job', action: 'end', user_id: user.id)
    Path.create(description: "Create MMO job for", object: 'Job', action: 'schedule', user_id: user.id)
    enterprise = Enterprise.all
    enterprise.each do |e|
      unless (e.company_name.include? 'Admin') || (e.company_name.include? 'Planning')
        MmoJob.set(wait: job_delay.minutes).perform_later(user, e.company_name)
        job_delay += 1
      end
    end
  end

end
