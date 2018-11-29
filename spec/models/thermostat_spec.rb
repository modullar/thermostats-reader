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


end
