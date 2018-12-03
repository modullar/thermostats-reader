require 'rails_helper'
require 'spec_helper'


RSpec.describe ReadingsController do
  let(:thermostat) {FactoryBot.create(:thermostat)}
  let(:reading_params){ FactoryBot.attributes_for(:reading) }

  describe 'POST #create' do

    context 'unauthorized request' do
      it 'must return 401 unauthorized' do
        post :create, params: {reading: reading_params}
        expect(response.status).to eq 401
      end
    end

    context 'authorized request' do
      it 'must create a background job to create the resource & returns 200 status with a valid response' do
        request.headers['Authorization'] = "Token #{thermostat.household_token}"
        post :create, params: {reading: reading_params}, format: :json
        expect(response.status).to eq 200
        expect(response.body).to eq({number: "#{thermostat.reload.uuid}-1"}.to_json)
        expect(ImportReadingWorker.jobs.size).to eq 1
      end
    end

  end

  describe 'GET #show' do
    let(:number){ "#{thermostat.reload.uuid}-1" }
    before do
      request.headers['Authorization'] = "Token #{thermostat.household_token}"
      post :create, params: {reading: reading_params}, format: :json
    end

    context 'record is not imported yet' do
      it 'must returns the reading details' do
        Sidekiq::Worker.drain_all
        get :show, params: {id: number}
        expect(response.status).to eq 200
        json_response = JSON.parse(response.body)
        expect(json_response.keys.map{|k| k.to_sym }).to match_array (ReadingSerializer.new(Reading.first).attributes.keys)
        expect(json_response["battery_charge"].to_s).to eq reading_params[:battery_charge]
        expect(json_response["temperature"].to_s).to eq reading_params[:temperature]
        expect(json_response["humidity"].to_s).to eq reading_params[:humidity]
        expect(json_response["number"]).to eq number
      end
    end

    context 'record is imported' do
      it 'must returns the reading details' do
        allow(ImportReadingWorker).to receive(:find_reading_data).and_return(ImportReadingWorker.jobs.first["args"])
        get :show, params: {id:  "#{thermostat.reload.uuid}-1"}
        expect(response.status).to eq 200
        json_response = JSON.parse(response.body)
        expect(json_response.keys.map{|k| k.to_sym }).to match_array (reading_params.keys + [:number])
        expect(json_response["battery_charge"].to_s).to eq reading_params[:battery_charge]
        expect(json_response["temperature"].to_s).to eq reading_params[:temperature]
        expect(json_response["humidity"].to_s).to eq reading_params[:humidity]
        expect(json_response["number"]).to eq number
      end
    end
  end
end
