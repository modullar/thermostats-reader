require 'rails_helper'
require 'spec_helper'

RSpec.describe ReadingsController do
  let(:thermostat) {FactoryBot.create(:thermostat)}
  let(:reading_params){ FactoryBot.attributes_for(:reading).merge({thermostat_id: thermostat.id}) }

  describe 'POST #create' do

    context 'unauthorized request' do
      it 'must return 401 unauthorized' do
        post :create, params: {reading: reading_params}
        expect(response.status).to eq 401
      end
    end

    context 'authorized request' do
      it 'must create a resource and returns 201' do
        request.headers['Authorization'] = "Token #{thermostat.household_token}"
        post :create, params: {reading: reading_params}, format: :json
        expect(response.status).to eq 201
      end
    end

  end
end
