require "rails_helper"

RSpec.describe Reading, type: :model do

  describe '.number' do
    let(:thermostat_1){ FactoryBot.create(:thermostat) }
    let(:thermostat_2){ FactoryBot.create(:thermostat) }

    let(:reading_1) { FactoryBot.create(:reading, thermostat: thermostat_1) }
    let(:reading_11) { FactoryBot.create(:reading, thermostat: thermostat_1) }
    let(:reading_2) { FactoryBot.create(:reading, thermostat: thermostat_2) }
    it 'should assign a sequential number for each thermostat' do
      expect(reading_1.number).to eq 1
      expect(reading_11.number).to eq 2
      expect(reading_2.number).to eq 1
    end
  end


end
