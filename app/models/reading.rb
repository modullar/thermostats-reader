class Reading < ApplicationRecord
  belongs_to :thermostat

  acts_as_sequenced column: :number, scope: :thermostat_id
end
