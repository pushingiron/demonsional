class Path < ApplicationRecord
  belongs_to :user

  def self.max_records(user)
    user.paths.destroy(order('created_at DESC').offset(100))
  end

end
