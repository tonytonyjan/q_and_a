# frozen_string_literal: true

require 'test_helper'

class SignInWithGoogleTest < ActiveSupport::TestCase
  MockUser = Struct.new(:id)

  class MockUserRepo
    def initialize(id)
      @id = id
    end

    def find_or_create_by_user_info(_user_info)
      MockUser.new(@id)
    end
  end

  class MockOauth2Client
    def get(_api_endpoint); end
  end

  test 'it will set session' do
    user_id = 123
    session = {}

    SignInWithGoogle.new(
      oauth2_client: MockOauth2Client.new,
      user_repo: MockUserRepo.new(user_id),
      session: session
    ).perform

    assert_equal user_id, session[SignInWithGoogle::KEY]
  end
end
