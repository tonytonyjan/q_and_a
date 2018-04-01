class Question < ApplicationRecord
  validates :title, :content, presence: true
  belongs_to :user

  def self.list
    includes(:user).order(updated_at: :desc)
  end

  def belongs_to?(user)
    return false if user.nil?
    user_id == user.id
  end
end
