class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  if Rails.env.production? || Rails.env.test?
    rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :first_name, :last_name, :birthdate, :mother, :group_code])
  end

  private

  def user_not_authorized
    redirect_to root_path, alert: 'Não autorizado'
  end

  def page_not_found
    alert = I18n.t('helpers.page.not_found')

    respond_to do |format|
      format.html { redirect_to(request.referrer || root_path, alert: alert) }
      format.json { render json: { type: 'not_found', title: alert, content: alert }, status: :not_found }
    end
  end
end
