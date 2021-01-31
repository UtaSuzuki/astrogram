class RelationshipsController < ApplicationController
  def follow
    current_user.follow(params[:id])
    redirect_to root_path
  end
  
  def unfollow
    current_user.unfollow(params[:id])
    redirect_to root_path
  end
  
  def index_following
    @user = User.find(current_user.id)
    @following = @user.following_user.where.not(id: current_user.id)
  end
  
  def index_follower
    @user = User.find(current_user.id)
    @follower = @user.follower_user.where.not(id: current_user.id)
  end
end
