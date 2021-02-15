class EventsController < ApplicationController
  def new
    @event = Event.new
  end
  
  def create
    @event = current_user.events.new(event_params)
    @event.update(recruit_status: true)
    if @event.save
      redirect_to events_path, success: 'イベントの投稿に成功しました'
    else
      flash.now[:danger] = 'イベントの投稿に失敗しました'
      render :new
    end
  end
  
  def index
    @events = Event.includes(:user)
  end
  
  def show
    @event = Event.find(params[:id])
    @author = User.find(@event.user_id).name
    @comments = @event.event_comments
    @comment = EventComment.new
  end
  
  def user_index
    @user = User.find(params[:id])
    @events = Event.where(user_id: params[:id])
    @comments = @events.includes(:comment)
  end
  
  private
  def event_params
    params.require(:event).permit(:title, :image, :date, :start_time, :end_time, :location, :deadline, :accept_number, :description)
  end
end
