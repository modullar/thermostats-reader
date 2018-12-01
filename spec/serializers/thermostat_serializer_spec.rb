require "rails_helper"

RSpec.describe ThermostatSerializer, type: :model do
  let(:thermostat){ FactoryBot.create(:thermostat) }

  let!(:readings){ FactoryBot.create_list(:reading,2, thermostat: thermostat,
                                                     temperature: 2,
                                                     humidity: 2,
                                                     battery_charge: 2) }
  let(:worker_args){
    [[3,4,5], [-3,-4,-5]]
  }

  let(:serializer) { described_class.new(thermostat) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }
  let(:subject) { JSON.parse(serialization.to_json) }

  context 'no readings in worker' do
    it 'has a maximum temperature equal to 2' do
      expect(subject['data']['max_temperature']).to eq 2
    end

    it 'has minimum temperature equal to 2' do
      expect(subject['data']['min_temperature']).to eq 2
    end

    it 'has average temperature of 2' do
      expect(subject['data']['average_temperature']).to eq 2
    end

    it 'has maximum humidity of 2' do
      expect(subject['data']['max_humidity']).to eq 2
    end

    it 'has minimum humidity of 2' do
      expect(subject['data']['min_humidity']).to eq 2
    end

    it 'has average humidity of 2' do
      expect(subject['data']['average_humidity']).to eq 2
    end

    it 'has maximum battery_charge of 2' do
      expect(subject['data']['max_battery_charge']).to eq 2
    end

    it 'has minimum battery_charge of 2' do
      expect(subject['data']['min_battery_charge']).to eq 2
    end

    it 'has average battery_charge of 2' do
      expect(subject['data']['average_battery_charge']).to eq 2
    end
  end

  context 'having readings in workers' do
    before do
      allow_any_instance_of(ThermostatSerializer).to receive(:readings_in_worker).and_return(worker_args)
    end

    it 'has a maximum amount of temperature equal to 3' do
      expect(subject['data']['max_temperature']).to eq 4
    end

    it 'has minimum temperature equal to -4' do
      expect(subject['data']['min_temperature']).to eq -4
    end

    it 'has average temperature equal to 1' do
      expect(subject['data']['average_temperature']).to eq 1
    end

    it 'has maximum humidity of 5' do
      expect(subject['data']['max_humidity']).to eq 5
    end

    it 'has minimum humidity of -5' do
      expect(subject['data']['min_humidity']).to eq -5
    end

    it 'has average humidity of 1' do
      expect(subject['data']['average_humidity']).to eq 1
    end

    it 'has maximum battery_charge of 3' do
      expect(subject['data']['max_battery_charge']).to eq 3
    end

    it 'has minimum battery_charge of -3' do
      expect(subject['data']['min_battery_charge']).to eq -3
    end

    it 'has average battery_charge of 1' do
      expect(subject['data']['average_battery_charge']).to eq 1
    end

  end

end
