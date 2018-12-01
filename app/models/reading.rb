# Please do not save and skip the callbacks
class Reading < ApplicationRecord
  belongs_to :thermostat


  after_save :update_thermostat_data

  def self.retrieve_reading_by_number(number)
    @reading = Reading.find_by(number: number) ||
      ImportReadingWorker.find_reading_by_number(number)
  end

  private

  def update_thermostat_data
    adjust_metrics
    increment_thermostat_total_readings
    thermostat.save!
  end

  def adjust_metrics
    Thermostat::METRICS.each do |metric|
      thermostat.send("adjust_max_#{metric}", self.attributes[metric])
      thermostat.send("adjust_min_#{metric}", self.attributes[metric])
      thermostat.send("adjust_average_#{metric}")
    end
  end

  def increment_thermostat_total_readings
    thermostat.increment_total_readings
  end

end
