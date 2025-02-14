class Tag < ApplicationRecord
  has_and_belongs_to_many :posts

  has_many :post_tags
  has_many :posts, through: :post_tags


   # 验证
  validates :name, presence: true, uniqueness: true

  # 作用域
  scope :popular, -> { joins(:posts).group(:id).order('COUNT(posts.id) DESC') }

  # 实例方法
  def post_count
    posts.count
  end
end
