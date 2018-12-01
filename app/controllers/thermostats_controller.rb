class ThermostatsController < ApplicationController
  before_action :set_thermostat, only: :show

  # GET /thermostats/1
  def show
    render json: @thermostat
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thermostat
      @thermostat = Thermostat.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def thermostat_params
      params.require(:thermostat).permit(:household_token, :location)
    end
end
