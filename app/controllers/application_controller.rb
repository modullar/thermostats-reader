include ActionController::HttpAuthentication::Basic::ControllerMethods
include ActionController::HttpAuthentication::Token::ControllerMethods


class ApplicationController < ActionController::API

  rescue_from Exception do |exception|
   logger.error "Exception occured #{exception}"
   render json: {error: 'an error occured, please contact the provider'}, status: 404
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @household_token = token
      @thermostat = Thermostat.find_by(household_token: @household_token)
    end
  end



end
