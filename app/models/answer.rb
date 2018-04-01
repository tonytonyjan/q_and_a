class Answer < ApplicationRecord
  include BelongsTo

  validates :content, presence: true
  belongs_to :user
  belongs_to :question

  def self.list
    includes(:user).order(updated_at: :desc)
  end
end
