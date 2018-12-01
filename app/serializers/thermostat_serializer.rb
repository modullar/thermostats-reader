require 'simple_math'

class ThermostatSerializer < ActiveModel::Serializer

  include SimpleMath
  attributes :data

  def data
    pending_readings = readings_in_worker
    return default_attributes if pending_readings.empty?
    new_attributes(pending_readings)
  end

  private

  # updating data from pending records in worker
  # args are the arguments of records in worker
  def new_attributes(args)
    stats = default_attributes
    update_stats(stats, args)
  end

  def update_stats(stats, args)
    Thermostat::METRICS.each do |metric|
      metric_array = send("#{metric}_array", args)
      stats["max_#{metric}"] = (metric_array + [stats["max_#{metric}"]]).max
      stats["min_#{metric}"] = (metric_array + [stats["min_#{metric}"]]).min
      stats["average_#{metric}"] = incremental_avg(stats["average_#{metric}"], metric_array, object.readings.count)
    end
    stats
  end

  def readings_args(readings_in_worker)
    readings_in_worker.map{|w| w.args }.map{|r| r.args}
  end

  def battery_charge_array(args)
    args.map{|e| e[0]}.map{|e| e.to_f }
  end

  def temperature_array(args)
    args.map{|e| e[1]}.map{|e| e.to_f }
  end

  def humidity_array(args)
    args.map{|e| e[2]}.map{|e| e.to_f }
  end

  def default_attributes
    object.attributes.except("household_token", "total_readings")
  end

  def readings_in_worker
    ImportReadingWorker.retrieve_readings_by_thermostat_uuid(object.uuid)
  end

end
