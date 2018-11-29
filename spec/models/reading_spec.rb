require "rails_helper"

RSpec.describe Reading, type: :model do

  let(:thermostat){ FactoryBot.create(:thermostat) }


  describe 'storing a reading in the database' do
    before do
      imported_readings = create_list(:reading, 2, thermostat: thermostat)
    end
    it 'the corresponding thermostat must have two readings' do
      expect(thermostat.total_readings). to eq 2
    end
  end

end
