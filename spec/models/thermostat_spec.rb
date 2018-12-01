require "rails_helper"

RSpec.describe Thermostat, type: :model do

  let(:thermostat){ FactoryBot.create(:thermostat) }


  describe '.total_readings' do
    before do
      imported_readings = create_list(:reading, 2, thermostat: thermostat)
    end
    it 'should have two total readings' do
      expect(thermostat.total_readings). to eq 2
    end

    describe '.increment_total_readings' do
      before do
        thermostat.increment_total_readings
      end
      it 'should increment the total readings when calling the method' do
        expect(thermostat.total_readings).to eq 3
      end
    end
  end


  describe 'adjust metrics methods' do
    before do
      thermostat.max_temperature = Faker::Number.between(40, 80)
      thermostat.min_temperature = Faker::Number.between(10, 39)
      thermostat.max_humidity = Faker::Number.between(40, 80)
      thermostat.min_humidity = Faker::Number.between(10, 39)
      thermostat.max_battery_charge = Faker::Number.between(40, 80)
      thermostat.min_battery_charge = Faker::Number.between(10, 39)
      thermostat.save!
    end

    describe '.adjust_max_metric' do

      context 'temperature' do
        it 'should assign the maximum temperature' do
          thermostat.adjust_max_temperature(Faker::Number.between(90, 100))
          expect(thermostat.max_temperature).to be_between(90,100)
        end
      end

      context 'battery_charge' do
        it 'should assign the max battery_charge value' do
          thermostat.adjust_max_battery_charge(Faker::Number.between(90, 100))
          expect(thermostat.max_battery_charge).to be_between(90,100)
        end
      end

      context 'humidity' do
        it 'should assign the max humidity value' do
          thermostat.adjust_max_humidity(Faker::Number.between(90, 100))
          expect(thermostat.max_humidity).to be_between(90,100)
        end
      end
    end

    describe '.adjust_min_metric' do
      context 'temperature' do
        it 'should assign the min temperature' do
          thermostat.adjust_min_temperature(Faker::Number.between(1, 9))
          expect(thermostat.min_temperature).to be_between(1,9)
        end
      end

      context 'humidity' do
        it 'should assign the min temperature' do
          thermostat.adjust_min_humidity(Faker::Number.between(1, 9))
          expect(thermostat.min_humidity).to be_between(1,9)
        end

      end

      context 'battery_charge' do
        it 'should assign the min temperature' do
          thermostat.adjust_min_battery_charge(Faker::Number.between(1, 9))
          expect(thermostat.min_battery_charge).to be_between(1,9)
        end
      end
    end

    describe '.adjust_average_metric' do
      let!(:readings) {FactoryBot.create_list(:reading, 2, thermostat: thermostat)}
      context 'humidity' do
        it 'should assign an average humidity' do
          thermostat.adjust_average_humidity
          expect(thermostat.average_humidity).to be_within(0.1).of readings.pluck(:humidity).sum / 2
        end

      end

      context 'temperature' do
        it 'should adjust the average temperature value' do
          thermostat.adjust_average_temperature
          expect(thermostat.average_temperature).to be_within(0.1).of readings.pluck(:temperature).sum / 2
        end
      end

      context 'battery_charge' do
        it 'should adjust the average battery_charge value' do
          thermostat.adjust_average_battery_charge
          expect(thermostat.average_battery_charge).to be_within(0.1).of(readings.pluck(:battery_charge).sum / 2)
        end
      end
    end
  end


end
