# frozen_string_literal: true

require 'webmock/minitest'

# https://developers.google.com/identity/protocols/OAuth2WebServer
class GoogleOauth2
  TOKEN_ENDPOINT = 'https://www.googleapis.com/oauth2/v4/token'

  class Error < RuntimeError; end
  class UnauthorizedError < Error; end
  class RequestError < Error; end

  def initialize(oauth_code:, client_id:, client_secret:, redirect_uri:)
    @oauth_code = oauth_code
    @client_id = client_id
    @client_secret = client_secret
    @redirect_uri  = redirect_uri
    @access_token = nil
  end

  def get(api_endpoint)
    exchange_authorization_code_for_access_token! unless @access_token
    uri = URI(api_endpoint)
    request = Net::HTTP::Get.new(
      uri.path,
      Authorization: "Bearer #{@access_token}"
    )

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      response = http.request(request)
      parsed_body = JSON.parse(response.body, symbolize_names: true)
      unless response.is_a? Net::HTTPOK
        raise RequestError, parsed_body[:message]
      end
      parsed_body
    end
  end

  private

  def exchange_authorization_code_for_access_token!
    request_params = {
      code: @oauth_code,
      client_id: @client_id,
      client_secret: @client_secret,
      redirect_uri: @redirect_uri,
      grant_type: 'authorization_code'
    }
    response = Net::HTTP.post_form URI(TOKEN_ENDPOINT), request_params
    parsed_body = JSON.parse(response.body, symbolize_names: true)

    unless response.is_a? Net::HTTPOK
      raise UnauthorizedError,
            parsed_body[:error_description] || parsed_body[:error]
    end

    @access_token = parsed_body[:access_token]
  end
end
