# frozen_string_literal: true

class SignInWithGoogle
  USERINFO_ENDPOINT = 'https://www.googleapis.com/userinfo/v2/me'

  def initialize(oauth2_client:, user_repo:, session:)
    @oauth2_client = oauth2_client
    @user_repo = user_repo
    @session = session
  end

  def perform
    user_info = @oauth2_client.get USERINFO_ENDPOINT
    user = @user_repo.find_or_create_by_user_info(user_info)
    @session[:user_id] = user.id
  end
end
