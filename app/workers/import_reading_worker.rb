require 'sidekiq/api'

class ImportReadingWorker
  include Sidekiq::Worker

  # The order of the arguments is important
  def perform(battery_charge, temperature, humidity, number, thermostat_id)
    Reading.create(battery_charge: battery_charge,
                   temperature: temperature,
                   humidity: humidity,
                   number: number,
                   thermostat_id: thermostat_id)
  end

  def self.next_reading_number(thermostat_id)
    thermostat = Thermostat.find(thermostat_id)
    seq = thermostat.total_readings + enqueued_readings_count(thermostat_id) + 1
    return "#{thermostat.uuid}-#{seq}"
  end

  def self.find_reading_by_number(number)
    reading = find_reading_data(number) || return
    {
      battery_charge: reading[0],
      temperature: reading[1],
      humidity: reading[2],
      number: number
    }
  end

  def self.retrieve_readings_by_thermostat_uuid(thermostat_uuid)
    readings = Sidekiq::Queue.new.select{
      |q| q.klass == self.name && Regexp.new(thermostat_uuid).match(q.args[3]) }
  end

  private

  def self.find_reading_data(number)
    reading_args = Sidekiq::Queue.new.select{
      |q| q.klass == self.name && q.args[3] ==  number }.first&.args
  end

  def self.enqueued_readings_count(thermostat_id)
    Sidekiq::Queue.new.select{
      |q| q.klass == self.name && q.args[4] ==  thermostat_id }.count
  end

end
