module Publishable
  extend ActiveSupport::Concern

  included do
    enum status: { draft: 0, published: 1, archived: 2 }
    scope :published, -> { where(status: :published) }
    scope :drafts, -> { where(status: :draft) }

    before_save :set_published_at, if: :publishing?
  end

  def publishing?
    status_changed? && published?
  end

  private

  def set_published_at
    self.published_at = Time.current
  end
end
