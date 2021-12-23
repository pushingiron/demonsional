class Contract < ApplicationRecord
  belongs_to :user

  validates :contract_name,
            :owner,
            :web_service,
            :service,
            :service_days,
            :mode,
            :effective_date,
            :expiration_date,

            presence: true

end
