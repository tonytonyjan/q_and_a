class Answer < ApplicationRecord
  include BelongsTo

  validates :title, :content, presence: true
  belongs_to :user
  belongs_to :question
end
