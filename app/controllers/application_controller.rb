class ApplicationController < ActionController::API
  # included from concerns to be used in controllers
  include Response
  include ExceptionHandler
end
