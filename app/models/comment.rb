class Comment < ApplicationRecord
  # 关联关系
  belongs_to :user
  belongs_to :post

  # 验证
  validates :content, presence: true
  validates :user, presence: true
  validates :post, presence: true

  # 作用域
  scope :recent, -> { order(created_at: :desc) }

  # 回调
  after_create :notify_post_owner

  private

  def notify_post_owner
    post.user.notifications.create(message: "您的帖子收到了新评论") if post.user.respond_to?(:notifications)
  end
end
