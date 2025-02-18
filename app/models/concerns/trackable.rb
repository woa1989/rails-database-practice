module Trackable
  extend ActiveSupport::Concern

  included do
    has_many :activities
    before_save :track_changes
  end

  def track_activity(action)
    activities.create(action: action, occurred_at: Time.current)
  end

  private

  def track_changes
    track_activity('updated') if changed?
  end
end
