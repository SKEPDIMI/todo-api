# Authentication controller is slim
# we have auth service architecture for that

class AuthenticationController < ApplicationController
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call

    json_response(auth_token: auth_token)
  end

  private
  def auth_params
    params.permit(:email, :password)
  end
end
