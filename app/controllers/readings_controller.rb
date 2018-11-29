class ReadingsController < ApplicationController

  before_action :authenticate, only: :create
  before_action :find_next_reading_number, only: :create

  before_action :set_reading, only: [:show]

  # GET /readings/1
  def show
    return render json: @reading if @reading
    render json: {error: "reading with the id #{params[:id]} is not found"}
  end

  # POST /readings
  def create
    push_to_worker
    render json: {number: @next_number}, status: :created, location: {number: @next_number}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reading
      @reading = Reading.find_by(number: params[:id]) ||
        ImportReadingWorker.find_reading_by_number(params[:id])
    end

    def push_to_worker
      ImportReadingWorker.perform_async(
        reading_params['battery_charge'].to_d,
        reading_params['temperature'].to_d,
        reading_params['humidity'].to_d,
        @next_number,
        @thermostat.id
      )
    end

    # Only allow a trusted parameter "white list" through.
    def reading_params
      params.require(:reading).permit(:temperature, :humidity, :battery_charge)
    end

    def find_next_reading_number
      @next_number = ImportReadingWorker.next_reading_number(@thermostat.id)
    end
end
