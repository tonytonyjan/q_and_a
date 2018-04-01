# frozen_string_literal: true

class Oauth2Controller < ApplicationController
  before_action :validate_params!

  def callback
    oauth2_client = GoogleOauth2.new(
      oauth_code: params[:code],
      client_id: Rails.application.secrets.oauth2_client_id,
      client_secret: Rails.application.secrets.oauth2_client_secret,
      redirect_uri: oauth2_callback_url
    )
    SignInWithGoogle.new(
      oauth2_client: oauth2_client,
      user_repo: User,
      session: session
    ).perform
    redirect_to root_path, notice: 'You are signed in.'
  rescue GoogleOauth2::Error => error
    redirect_to root_path, alert: error.message
  end

  private

  def validate_params!
    if params[:error]
      redirect_to root_path, alert: params[:error]
    elsif !params[:code]
      redirect_to root_path, alert: 'missing authentication code'
    end
  end
end
