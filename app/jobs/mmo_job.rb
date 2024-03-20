class MmoJob < ApplicationJob
  queue_as :mmo

  def perform(user, enterprise)
    Path.create(description: "Starting MMO for #{enterprise}", object: 'Job', action: 'begin', user_id: user.id)
    MercuryGateApiServices.mg_post_edge(user, MercuryGateJson.rate_table(user, enterprise), 'execjs')
    Path.create(description: "MMO complete for #{enterprise}", object: 'job', action: 'end', user_id: user.id)
    TenderJob.set(wait: 1.minutes).perform_later(user) if enterprise.include? 'Analytics'
  end

end
