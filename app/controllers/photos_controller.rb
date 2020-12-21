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
    @photos = Photo.all
    @autors = User.joins(conditions: :photos).pluck("name")
  end
  
  def show
    @photo = Photo.find(params[:id])
    @author = User.joins(conditions: :photos).pluck("name")[@photo.id-1]
    @condition = Condition.find(@photo.condition_id)
    @itemLink  = ItemLink.find_by(condition_id: @condition.id)
  end
  
  def purchase
    @photo = Photo.find(params[:id])
    @author = User.joins(conditions: :photos).pluck("name")[@photo.id-1]
  end
  
  private
  def photo_params
    params.require(:photo).permit(:condition_id, :title, :image, :date, :time, :location, :description, :price)
  end
end
