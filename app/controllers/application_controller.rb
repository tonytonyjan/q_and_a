class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[SignInWithGoogle::KEY])
  end

  def authenticate_user!
    redirect_back fallback_location: root_path, alert: 'please sign in' if current_user.nil?
  end
end
