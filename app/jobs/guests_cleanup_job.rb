class GuestsCleanupJob < ApplicationJob
  queue_as :default

  def perform(work)
    case work
    when 'easy'
      p 'easy amount of work'
      sleep 5
      p 'that was easy'
    when 'hard'
      p 'hard amount of work'
      sleep 20
      p 'that was hard'
    else
      p "what is #{work}"
    end
  end
end
