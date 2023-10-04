# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    permit_keys = %i[name address postal_code self_introduction]
    devise_parameter_sanitizer.permit(:sign_up, keys: permit_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: permit_keys)
  end
end
