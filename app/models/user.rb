class User < ApplicationRecord
  include NameValidatable
  include Trackable

  has_many :posts, dependent: :destroy
  has_many :comments

  before_save :normalize_name
  before_save :normalize_email
  after_create :send_welcome_email

  class InvalidUserError < StandardError; end

  # 关联关系
  has_one :profile, dependent: :destroy
  has_many :posts, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_posts, -> { where(status: "active") }, class_name: "Post"
  has_many :published_posts, -> { published }, class_name: "Post"

  # 验证
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # 作用域
  scope :active, -> { where(active: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :with_posts, -> { joins(:posts).distinct }

  # 获取用户的活跃帖子
  has_many :active_posts, -> { where(status: "active").order(created_at: :desc) },
          class_name: "Post"

  # 获取用户最近的帖子
  has_many :recent_posts, -> { order(created_at: :desc).limit(5) },
          class_name: "Post"

  # 新增示例：使用pluck获取活跃用户邮箱（查询优化示例）
  def self.active_emails
    where(active: true).pluck(:email)
  end

  # 创建一个用户
  def useCreate
    User.create(name: "John Doe", email: "john@example.com")
  end

  # 使用new 创建一个用户
  def useNew
    user = User.new(name: "John Doe", email: "john@example.com")
    user.save
  end

  # 使用 `create!` 方法并添加错误处理
  def useCreateBang
    begin
      user = User.create!(name: "John Doe", email: "john@example.com")
      raise InvalidUserError, "用户创建失败" unless user.persisted?
      user
    rescue ActiveRecord::RecordInvalid => e
      errors.add(:base, "验证错误: #{e.record.errors.full_messages.join(', ')}")
      nil
    rescue InvalidUserError => e
      errors.add(:base, e.message)
      nil
    end
  end

  # 新增示例：事务处理余额转移
  def transfer_balance(amount, recipient)
    User.transaction do
      raise "余额不足" if self.balance < amount
      self.update!(balance: self.balance - amount)
      recipient.update!(balance: recipient.balance + amount)
    end
  rescue => e
    Rails.logger.error "余额转移失败: #{e.message}"
    false
  end

  # 自定义错误处理回调
  after_validation :log_errors, if: -> { errors.any? }

  private

  def log_errors
    Rails.logger.error "用户验证错误: #{errors.full_messages.join(', ')}"
  end

  def normalize_email
    self.email = email.downcase.strip
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
