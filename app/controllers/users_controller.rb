class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new( user_params )
    if @user.save
      redirect_to root_path, success: "アカウント登録が完了しました"
    else
      flash.now[:danger] = "アカウント登録に失敗しました"
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(current_user.id)
  end
  
  def update
    user = User.find(current_user.id)
    
    if user.authenticate(authenticate_params[:password_old]) && user.update(user_params)
      redirect_to user_path(id: current_user.id), success: "ユーザ情報を更新しました"
    else
      flash.now[:danger] = "ユーザ情報の更新に失敗しました"
      redirect_to user_path(id: current_user.id), danger: "ユーザ情報の更新に失敗しました"
      # render :show, { id: current_user.id }
    end
    
  end
  
  def destroy
    @user = User.find(current_user.id)
    if @user.destroy
      redirect_to root_path, success: "アカウントを削除しました"
    else
      flash.now[:danger] = "アカウントの削除に失敗しました"
      render :show
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :kind, :image, :profile)
  end
  
  def authenticate_params
    params.require(:user).permit(:password_old)
  end
end
