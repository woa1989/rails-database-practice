class UserService
  def self.create_with_profile(user_params, profile_params)
    ActiveRecord::Base.transaction do
      user = User.new(user_params)
      
      # 自定义验证
      unless valid_password?(user_params[:password])
        user.errors.add(:password, '密码强度不够')
        raise ActiveRecord::RecordInvalid.new(user)
      end
      
      user.save!
      
      # 创建关联的 profile
      profile = user.build_profile(profile_params)
      profile.save!
      
      # 发送欢迎邮件（异步）
      WelcomeMailerJob.perform_later(user.id)
      
      user
    end
  rescue ActiveRecord::RecordInvalid => e
    # 记录详细错误信息
    Rails.logger.error("用户创建失败: #{e.record.errors.full_messages.join(', ')}")
    raise
  rescue => e
    # 处理其他异常
    Rails.logger.error("创建用户时发生未知错误: #{e.message}")
    raise
  end
  
  private
  
  def self.valid_password?(password)
    # 实现密码强度检查逻辑
    password.present? &&
      password.length >= 8 &&
      password =~ /[A-Z]/ &&
      password =~ /[a-z]/ &&
      password =~ /[0-9]/
  end
end