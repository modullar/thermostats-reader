require "rails_helper"

RSpec.describe Reading, type: :model do

  let(:thermostat){ FactoryBot.create(:thermostat) }


  describe 'storing a reading in the database' do

    let!(:min_reading){ FactoryBot.create(:reading,
                                         thermostat: thermostat,
                                         temperature: Faker::Number.between(1, 10),
                                         humidity: Faker::Number.between(1, 10),
                                         battery_charge: Faker::Number.between(1, 10))
                                         }

    let!(:max_reading){ FactoryBot.create(:reading,
                                        thermostat: thermostat,
                                        temperature: Faker::Number.between(20, 30),
                                        humidity: Faker::Number.between(20, 30),
                                        battery_charge: Faker::Number.between(20, 30))
                                        }

    describe '.update_thermostat_data' do
      it 'should update the total reading of the corresponding thermostat' do
        expect(thermostat.total_readings). to eq 2
      end

      it 'should assign the min, max and average values for the thermostat' do
        expect(thermostat.reload.max_temperature).to eq max_reading.temperature
        expect(thermostat.reload.max_humidity).to eq max_reading.humidity
        expect(thermostat.reload.max_battery_charge).to eq max_reading.battery_charge

        expect(thermostat.min_temperature).to eq min_reading.temperature
        expect(thermostat.min_humidity).to eq min_reading.humidity
        expect(thermostat.min_battery_charge).to eq min_reading.battery_charge

        expect(thermostat.average_humidity).to eq [max_reading, min_reading].map{|r| r.humidity}.inject(:+) / 2
        expect(thermostat.average_temperature).to eq [max_reading, min_reading].map{|r| r.temperature}.inject(:+) / 2
        expect(thermostat.average_battery_charge).to eq [max_reading, min_reading].map{|r| r.battery_charge}.inject(:+) / 2
      end

    end
  end

end
