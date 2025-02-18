class Post < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # 启用乐观锁
  def safe_update(attributes)
    begin
      update!(attributes)
    rescue ActiveRecord::StaleObjectError
      errors.add(:base, "文章已被其他用户修改，请刷新后重试")
      false
    end
  end

  # 验证
  validates :title, presence: { message: "标题不能为空" }, length: { maximum: 255 }
  validates :content, presence: { message: "内容不能为空" }
  validates :user, presence: { message: "用户不能为空" }
  validates :status, inclusion: { in: %w[draft active published], message: "状态值无效" }

  # 自定义验证示例
  validate :appropriate_content

  # 作用域
  scope :active, -> { where(status: 'active').includes(:user) }
  scope :recent, -> { order(created_at: :desc) }
  scope :published, -> { where(status: 'published') }
  scope :with_comments, -> { includes(:comments).where.not(comments: { id: nil }) }
  scope :by_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }

  # 回调
  after_create :notify_user

  # 计数器缓存
  belongs_to :user, counter_cache: true

  private

  def notify_user
    user.notifications.create(message: "新帖子已创建：#{title}") if user.respond_to?(:notifications)
  end

  def appropriate_content
    # 在此处加入审核逻辑
  end
end
