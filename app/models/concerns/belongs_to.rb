module BelongsTo
  def belongs_to?(user)
    return false if user.nil?
    user_id == user.id
  end
end
