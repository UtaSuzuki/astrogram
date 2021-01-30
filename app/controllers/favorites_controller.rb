class FavoritesController < ApplicationController
  def index
    @favorite_photos = current_user.favorite_photos
  end
  
  def create
    favorite = Favorite.new
    favorite.user_id = current_user.id
    favorite.photo_id = params[:photo_id]
    redirect_flg = params[:redirect_flg]
    if redirect_flg.to_i == 0
      if favorite.save
        redirect_to photos_path, success: 'いいねしました'
      else
        redirect_to photos_path, danger: 'いいねできませんでした'
      end
    else
      if favorite.save
        redirect_to photo_path(params[:photo_id]), success: 'いいねしました'
      else
        redirect_to photo_path(params[:photo_id]), danger: 'いいねできませんでした'
      end
    end
  end
  
  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, photo_id: params[:photo_id])
    redirect_flg = params[:redirect_flg]
    if redirect_flg.to_i == 0
      if favorite.delete
        redirect_to photos_path, success: 'いいねを解除しました'
      else
        redirect_to photos_path, danger: 'いいねを解除できませんでした'
      end
    else
      if favorite.delete
        redirect_to photo_path(params[:photo_id]), success: 'いいねを解除しました'
      else
        redirect_to photo_path(params[:photo_id]), danger: 'いいねを解除できませんでした'
      end
    end
  end
end
