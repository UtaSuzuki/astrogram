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
    @photos = Photo.includes(condition: :user)
  end
  
  def show
    @photo = Photo.includes(condition: :user).find(params[:id])
    @itemLink  = ItemLink.find_by(condition_id: @photo.condition.id)
  end
  
  def user_index
    @photos = Photo.includes(condition: :user).where(users: {id: current_user.id})
  end
  
  private
  def photo_params
    params.require(:photo).permit(:condition_id, :title, :image, :date, :time, :location, :description, :price)
  end
end
