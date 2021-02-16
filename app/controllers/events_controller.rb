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
    @comments = @event.event_comments
    @comment = EventComment.new
  end
  
  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    event = Event.find(params[:id])
    
    if event.update(event_params)
      redirect_to event_path(event.id), success: "投稿内容を更新しました"
    else
      flash.now[:danger] = "投稿内容の更新に失敗しました"
      redirect_to event_path(event.id), danger: "投稿内容の更新に失敗しました"
      # render :show, { id: current_user.id }
    end
    
  end
  
  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      redirect_to events_path, success: "投稿写真を削除しました"
    else
      flash.now[:danger] = "投稿写真の削除に失敗しました"
      render :show
    end
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
