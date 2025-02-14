class UserDecorator < Draper::Decorator
  delegate_all

  # 格式化用户名和邮箱显示
  def full_info
    "#{object.name} (#{object.email})"
  end

  # 用户状态显示
  def status_text
    object.active? ? "活跃" : "未激活"
  end

  # 格式化最近发帖时间
  def latest_post_time
    if object.recent_posts.first
      h.time_ago_in_words(object.recent_posts.first.created_at) + "前"
    else
      "暂无发帖"
    end
  end

  # 格式化活跃帖子数量
  def active_posts_count
    "#{object.active_posts.count} 篇活跃帖子"
  end

  # 格式化评论数量
  def comments_count
    "发表了 #{object.comments.count} 条评论"
  end
end
