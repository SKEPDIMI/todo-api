class ApplicationController < ActionController::API
  # included from concerns to be used in controllers
  include Response
  include ExceptionHandler

  # we want @current_user to be authorized on every request
  before_action :authorize_request
  # except when they login
  skip_before_action :authorize_request, only: :authenticate
  attr_reader :current_user

  private
  def authorize_request
    # request.headers => { 'Authorization' => auth_token }
    # AuthorizeApiRequest.new(request.headers).call => { user: { ... } }
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
end
