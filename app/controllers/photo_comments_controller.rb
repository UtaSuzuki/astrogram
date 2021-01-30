class PhotoCommentsController < ApplicationController
  def new
    @comment = PhotoComment.new
  end

  def create
    @comment = current_user.photo_comments.new(comment_params)
    @comment.photo_id = params[:photo_id]
    if @comment.save
      redirect_to photo_path(params[:photo_id]), success: 'コメントしました'
    else
      redirect_to photo_path(params[:photo_id]), danger: 'コメントできませんでした'
    end
  end

  private
  def comment_params
    params.require(:photo_comment).permit(:message)
  end
end
