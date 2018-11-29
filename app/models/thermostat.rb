class Thermostat < ApplicationRecord

  has_many :readings

  def increment_total_readings
    self.total_readings += 1
    self.save!
  end

end
