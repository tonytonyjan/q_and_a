# frozen_string_literal: true

require 'test_helper'

class GoogleOauth2Test < ActiveSupport::TestCase
  test '#get' do
    oauth_code = 'oauth_code'
    client_id = 'client_id'
    client_secret = 'client_secret'
    redirect_uri = 'redirect_uri'
    access_token = 'access_token'

    stub_request(:post, GoogleOauth2::TOKEN_ENDPOINT)
      .with(
        body: URI.encode_www_form(
          code: oauth_code,
          client_id: client_id,
          client_secret: client_secret,
          redirect_uri: redirect_uri,
          grant_type: 'authorization_code'
        )
      )
      .to_return(body: { access_token: access_token }.to_json)

    api_endpoint = 'http://example.com/'
    expected = { foo: 'bar' }

    stub_request(:get, api_endpoint)
      .with(
        headers: { 'Authorization': "Bearer #{access_token}" }
      ).to_return(body: expected.to_json)

    assert_equal expected, GoogleOauth2.new(
      oauth_code: oauth_code,
      client_id: client_id,
      client_secret: client_secret,
      redirect_uri: redirect_uri
    ).get(api_endpoint)
  end
end
