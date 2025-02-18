class UserRegistrationService
  def initialize(params)
    @params = params
  end

  def call
    user = User.new(@params)
    if user.save
      send_welcome_email(user)
      true
    else
      false
    end
  end

  private

  def send_welcome_email(user)
    UserMailer.welcome(user).deliver_later
  end

end
