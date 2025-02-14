class WelcomeController < ApplicationController
  def index
    @posts = Post.all

    @user = User.first
  end
end
