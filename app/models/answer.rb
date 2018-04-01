class Answer < ApplicationRecord
  include BelongsTo

  validates :content, presence: true
  belongs_to :user
  belongs_to :question
end
