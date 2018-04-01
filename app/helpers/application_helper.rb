module ApplicationHelper
  def google_sign_in_url
    params = {
      client_id: Rails.application.secrets.oauth2_client_id,
      redirect_uri: oauth2_callback_url,
      response_type: 'code',
      scope: 'https://www.googleapis.com/auth/userinfo.profile'
    }
    "https://accounts.google.com/o/oauth2/v2/auth?#{params.to_query}"
  end
end
