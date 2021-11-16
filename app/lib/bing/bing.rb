module Bing

  include MercuryGateService

  def retrieve_events
    p 'retrieve loads'
    loads = mg_post_list_report('PlanEvent', 'automation-routes', 1, 'In Transit')
    p loads
  end

  def self.say_hi
    puts 'hi bing a'
  end

end
