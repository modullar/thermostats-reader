class Thermostat < ApplicationRecord

  METRICS = %w(temperature humidity battery_charge)

  has_many :readings

  def increment_total_readings
    self.total_readings += 1
  end

  METRICS.each do |metric|
    define_method "adjust_max_#{metric}" do |val|
      self.write_attribute("max_#{metric}",
                           val) if self.attributes["max_#{metric}"] < val
    end

    define_method "adjust_min_#{metric}" do |val|
      self.write_attribute("min_#{metric}",
                           val) if self.attributes["min_#{metric}"] > val
    end

    define_method "adjust_average_#{metric}" do
      self.write_attribute("average_#{metric}",
                           self.readings.average(metric.to_sym))
    end
  end




end
