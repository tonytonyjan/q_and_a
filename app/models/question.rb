class Question < ApplicationRecord
  include BelongsTo

  validates :title, :content, presence: true
  belongs_to :user

  def self.list
    includes(:user).order(updated_at: :desc)
  end
end
