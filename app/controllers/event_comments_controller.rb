class EventCommentsController < ApplicationController
  def new
    @comment = EventComment.new
  end

  def create
    @comment = current_user.event_comments.new(comment_params)
    @comment.event_id = params[:event_id]
    if @comment.save
      redirect_to event_path(params[:event_id]), success: 'コメントしました'
    else
      redirect_to event_path(params[:event_id]), danger: 'コメントできませんでした'
    end
  end

  private
  def comment_params
    params.require(:event_comment).permit(:message)
  end
end
