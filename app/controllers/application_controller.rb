class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_person!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :setPoints

  def setPoints
    @points = [1, 2, 3, 5, 8, 13]
  end

  protected
    def configure_permitted_parameters
      # Configuring accepted parameters to devise forms
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
    end
end
