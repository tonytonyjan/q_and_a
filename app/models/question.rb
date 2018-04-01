class Question < ApplicationRecord
  include BelongsTo

  validates :title, :content, presence: true
  belongs_to :user
  has_many :answers

  def self.list
    includes(:user).order(updated_at: :desc)
  end
end
