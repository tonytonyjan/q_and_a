# frozen_string_literal: true

require 'test_helper'

class Oauth2ControllerTest < ActionDispatch::IntegrationTest
  test 'should get callback' do
    stub_request(:post, GoogleOauth2::TOKEN_ENDPOINT)
      .to_return(body: { access_token: 'access_token' }.to_json)
    google_uid = SecureRandom.hex
    stub_request(:get, SignInWithGoogle::USERINFO_ENDPOINT)
      .to_return(body: {
        id: google_uid,
        name: 'user',
        picture: 'picture'
      }.to_json)
    assert_difference('User.count') do
      get oauth2_callback_url, params: { code: 'code' }
    end
    assert_redirected_to root_path
  end
end
