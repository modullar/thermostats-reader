class Reading < ApplicationRecord
  belongs_to :thermostat


  before_save :increment_thermostat_total_readings


  private

  def increment_thermostat_total_readings
    self.thermostat.increment_total_readings
  end

end
