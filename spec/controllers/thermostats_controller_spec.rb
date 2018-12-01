require 'rails_helper'
require 'spec_helper'


RSpec.describe ThermostatsController do

  let(:thermostat) {FactoryBot.create(:thermostat)}
  let!(:reading){ FactoryBot.create(:reading, thermostat: thermostat) }

  describe 'GET #show' do

    it 'must returns the thermostat detail of the posted readings' do
      get :show, params: {id: thermostat.id}
      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      expect(json_response.keys.map{|k| k.to_sym }).to match_array (ThermostatSerializer.new(Thermostat.first).attributes.keys)
      expect(json_response["data"]['max_temperature']).to eq(reading.temperature)
      expect(json_response["data"]['min_temperature']).to eq(reading.temperature)
      expect(json_response["data"]['average_temperature']).to eq(reading.temperature)

      expect(json_response["data"]['max_humidity']).to eq(reading.humidity)
      expect(json_response["data"]['min_humidity']).to eq(reading.humidity)
      expect(json_response["data"]['average_humidity']).to eq(reading.humidity)

      expect(json_response["data"]['max_battery_charge']).to eq(reading.battery_charge)
      expect(json_response["data"]['min_battery_charge']).to eq(reading.battery_charge)
      expect(json_response["data"]['average_battery_charge']).to eq(reading.battery_charge)

    end
  end
end
