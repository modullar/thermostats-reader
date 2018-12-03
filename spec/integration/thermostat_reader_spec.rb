require 'swagger_helper'
require 'rails_helper'

describe 'Thermostats Reader API' do
  let(:thermostat){ FactoryBot.create(:thermostat) }
  let(:Authorization) {"Bearer #{thermostat.household_token}"}

  path '/readings' do
    post 'Creates a reading' do
      consumes 'application/json'
      parameter name: :reading, in: :body, schema: {
        type: :object,
        properties: {
          temperature: { type: :number },
          humidity: { type: :number },
          battery_charge: {type: :number}
        },
        required: [ 'temperature', 'humidity', 'battery_charge' ]
      }


      response '200', 'reading is about to be created' do

        schema type: :object,
          properties: {
            number: { type: :string },
          },
          required: [ 'number']


        let(:reading){ FactoryBot.attributes_for(:reading) }
        run_test!
      end

      response '404', 'invalid request' do
        let(:reading) { { falsy_hash: 'foo' } }
        run_test!
      end

    end
  end

  path '/readings/{id}' do
    get 'Retrieves a reading' do
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'reading found' do
        schema type: :object,
          properties: {
            number: { type: :string },
            temperature: { type: :number },
            humidity: { type: :number },
            battery_charge: {type: :number}          },
          required: [ 'number', 'temperature', 'humidity', 'battery_charge']

        let(:id) { FactoryBot.create(:reading, number: '123').number }
        run_test!
      end

    end
  end



  path '/stats/{id}' do
    get 'Retrieves a thermostat data' do
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'reading found' do
        schema type: :object,
          properties: {
            data: { type: :json },
          },
          required: [ 'data']


        let(:reading){ FactoryBot.create(:reading, thermostat: thermostat)}
        let(:id) { thermostat.id }
        run_test!
      end

    end
  end



end
