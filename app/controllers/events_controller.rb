class EventsController < ApplicationController
  def index
    @events = Event.all
  end
  
  def new
    @event = Event.new
  end
  
  def create
    @event = current_user.events.new(event_params)
    if @event.save
      redirect_to events_path, success: 'イベントの投稿に成功しました'
    else
      flash.now[:danger] = 'イベントの投稿に失敗しました'
      render :new
    end
  end
  
  private
  def event_params
    params.require(:event).permit(:title, :date, :start_time, :location, :description)
  end
end
