ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def sign_in_as(user)
    stub_request(:post, GoogleOauth2::TOKEN_ENDPOINT)
      .to_return(body: { access_token: 'access_token' }.to_json)
    stub_request(:get, SignInWithGoogle::USERINFO_ENDPOINT)
      .to_return(body: {
        id: user.google_uid,
        name: user.name,
        picture: user.avatar
      }.to_json)
    get oauth2_callback_url, params: { code: 'code' }
  end
end
