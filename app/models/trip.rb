class Trip < ApplicationRecord
  has_many :trip_versions, dependent: :destroy

  validates :status, inclusion: { in: %w[Unstarted In_progress Completed] }
  validates :estimated_arrival, :estimated_completion, presence: true

  def check_in(user)
    if can_check_in?(user)
      update(status: 'In_progress', check_in_time: Time.current)
    else
      false
    end
  end

  def check_out(user)
    if can_check_out?(user)
      update(status: 'Completed', check_out_time: Time.current)
    else
      false
    end
  end

  def reassign(user, new_assignee)
    if can_reassign?(user, new_assignee)
      TripVersion.create!(trip: self, owner: user, assignee: new_assignee)
    else
      false
    end
  end

  def self.for_user(user)
    joins(:trip_versions)
      .where('trip_versions.owner_id = ? OR trip_versions.assignee_id = ?', user.id, user.id)
      .distinct
  end

  private

  def can_check_in?(user)
    return false unless can_perform?(required_status: 'Unstarted', user: user)
    true
  end

  def can_check_out?(user)
    return false unless can_perform?(required_status: 'In_progress', user: user)
    true
  end

  def can_reassign?(user, new_assignee)
    return false unless can_perform?(required_status: 'Unstarted', user: user)
    if previous_assignees.include?(new_assignee.id)
      errors.add(:base, 'Assignee already assigned in past')
      return false
    end

    true
  end


  def can_perform?(required_status: 'Unstarted', user:)
    latest_version = trip_versions.order(:created_at).last
    unless latest_version&.assignee == user
      errors.add(:base, 'Unauthorized as User is not Assignee')
      return false
    end

    unless status == required_status
      errors.add(:base, "Status should be #{required_status}")
      return false
    end
    true
  end

  def previous_assignees
    trip_versions.pluck(:assignee_id)
  end
end
