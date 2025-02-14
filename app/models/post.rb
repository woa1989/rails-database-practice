class Post < ApplicationRecord
  belongs_to :user

  has_and_belongs_to_many :tags

  has_many :post_tags
  has_many :tags, through: :post_tags

  # 验证
  validates :title, presence: true
  validates :content, presence: true
  validates :user, presence: true

  # 作用域
  scope :active, -> { where(status: 'active') }
  scope :recent, -> { order(created_at: :desc) }
  scope :published, -> { where(status: 'published') }

  # 回调
  after_create :notify_user

  # 计数器缓存
  belongs_to :user, counter_cache: true

  private

  def notify_user
    user.notifications.create(message: "新帖子已创建：#{title}") if user.respond_to?(:notifications)
  end
end
