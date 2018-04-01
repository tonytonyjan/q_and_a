# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#find_or_create_by_user_info to find user' do
    user_info = {
      id: 'john_google_uid',
      name: 'John',
      picture: 'https://api.adorable.io/avatars/285/john.png'
    }

    assert_equal users(:john), User.find_or_create_by_user_info(user_info)
  end

  test '#find_or_create_by_user_info to create user' do
    random_hex = SecureRandom.hex
    user_info = {
      id: random_hex,
      name: random_hex,
      picture: 'https://api.adorable.io/avatars/285/mary.png'
    }
    assert_difference('User.count') do
      user = User.find_or_create_by_user_info(user_info)
      assert_equal user_info[:name], user.name
      assert_equal user_info[:id], user.google_uid
      assert_equal user_info[:picture], user.avatar
    end
  end
end
