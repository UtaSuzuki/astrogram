class PhotosController < ApplicationController
  
  def new
    @photo = Photo.new
    @condition = Condition.where(user_id: current_user.id).pluck('title', 'id')
  end
  
  def create
    @photo = Photo.new(photo_params)
    @photo.update(categorization_id: 1)
    @photo.update(size_id: 1)
    if @photo.save
      redirect_to photos_path, success: '写真の投稿に成功しました'
    else
      flash.now[:danger] = '写真の投稿に失敗しました'
      render :new
    end
  end
  
  def index
    @photos = Photo.includes([:favorite_users, condition: :user])
    @comments = PhotoComment.all
  end
  
  def show
    @photo = Photo.includes(condition: :user).find(params[:id])
    @itemLink  = ItemLink.find_by(condition_id: @photo.condition.id)
    @comments = @photo.photo_comments
    @comment = PhotoComment.new
  end
  
  def edit
    @photo = Photo.includes(condition: :user).find(params[:id])
    @condition = Condition.where(user_id: current_user.id).pluck('title', 'id')
  end
  
  def update
    photo = Photo.includes(condition: :user).find(params[:id])
    
    if photo.update(photo_params)
      redirect_to photo_path(photo.id), success: "投稿内容を更新しました"
    else
      flash.now[:danger] = "投稿内容の更新に失敗しました"
      redirect_to photo_path(photo.id), danger: "投稿内容の更新に失敗しました"
      # render :show, { id: current_user.id }
    end
    
  end
  
  def destroy
    @photo = Photo.includes(condition: :user).find(params[:id])
    if @photo.destroy
      redirect_to root_path, success: "投稿写真を削除しました"
    else
      flash.now[:danger] = "投稿写真の削除に失敗しました"
      render :show
    end
  end
  
  def user_index
    @user   = User.find(params[:id])
    @photos = Photo.includes(condition: :user).where(users: {id: params[:id]})
  end
  
  private
  def photo_params
    params.require(:photo).permit(:condition_id, :title, :image, :date, :time, :location, :description, :price)
  end
end
