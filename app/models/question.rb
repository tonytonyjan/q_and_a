class Question < ApplicationRecord
  include BelongsTo

  validates :title, :content, presence: true
  belongs_to :user
  has_many :answers, dependent: :destroy

  def self.list
    includes(:user).order(updated_at: :desc)
  end

  def self.search(text)
    quoted = connection.quote(text)
    where("search_vector @@ plainto_tsquery(#{quoted})")
      .order("ts_rank_cd(search_vector, plainto_tsquery(#{quoted})) DESC")
  end
end
