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
    @user = User.find(params[:id])
    @following = @user.following_user.where.not(id: params[:id])
  end
  
  def index_follower
    @user = User.find(params[:id])
    @follower = @user.follower_user.where.not(id: params[:id])
  end
end
