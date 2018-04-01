class Answer < ApplicationRecord
  validates :title, :content, presence: true
  belongs_to :user
  belongs_to :question
end
