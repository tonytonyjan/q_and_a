# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, :avatar, :google_uid, presence: true
  has_many :questions
  has_many :answers

  def self.find_or_create_by_user_info(user_info)
    if (user = find_by(google_uid: user_info[:id]))
      user
    else
      create!(
        google_uid: user_info[:id],
        name: user_info[:name],
        avatar: user_info[:picture]
      )
    end
  end
end
