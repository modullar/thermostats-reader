include ActionController::HttpAuthentication::Basic::ControllerMethods
include ActionController::HttpAuthentication::Token::ControllerMethods


class ApplicationController < ActionController::API

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @household_token = token
      Thermostat.find_by(household_token: @household_token)
    end
  end

end
