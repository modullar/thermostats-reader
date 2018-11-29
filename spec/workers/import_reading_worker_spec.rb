require 'rails_helper'
require 'spec_helper'

RSpec.describe ImportReadingWorker, type: :worker do

  let(:thermostat) {FactoryBot.create(:thermostat)}
  let(:reading_params){ FactoryBot.attributes_for(:reading) }

  describe '#perform_async' do

    it 'enque a reading import worker & execute it' do
      expect {
        ImportReadingWorker.
          perform_async(reading_params[:battery_charge],
                        reading_params[:temperature],
                        reading_params[:humidity],
                        reading_params[:number],
                        thermostat.id)}.to change(ImportReadingWorker.jobs, :size).by(1)
      expect(Reading.count).to eq 0
      expect{ Sidekiq::Worker.drain_all }.to change(Reading, :count).by 1
      expect(ImportReadingWorker.jobs.size).to eq 0
    end
  end

  describe '#next_reading_number' do
    before do
      readings = FactoryBot.create_list(:reading, 2, thermostat: thermostat)
    end

    it 'should return the number of the to be-imported reading' do
      expect(ImportReadingWorker.next_reading_number(thermostat.id)).to eq ("#{thermostat.reload.uuid}-3")
      ImportReadingWorker.
        perform_async(reading_params[:battery_charge],
                      reading_params[:temperature],
                      reading_params[:humidity],
                      reading_params[:number],
                      thermostat.id)
      allow(ImportReadingWorker).to receive(:enqueued_readings_count).and_return(ImportReadingWorker.jobs.size)
      expect(ImportReadingWorker.next_reading_number(thermostat.id)).to eq ("#{thermostat.uuid}-4")
    end
  end

end
