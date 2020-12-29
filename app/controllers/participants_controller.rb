class ParticipantsController < ApplicationController
  def create
    participant = Participant.new
    participant.user_id = current_user.id
    participant.event_id = params[:event_id]
    if participant.save
      redirect_to events_path, success: "イベントへ参加登録しました"
    else
      redirect_to events_path, danger: "イベントへ参加登録できませんでした"
    end
  end
  
  def index
    @participant_events = current_user.paticipant_events
  end
  
  def destroy
    participant = Participant.find_by(user_id: current_user.id, event_id: params[:event_id])
    if participant.delete
      redirect_to events_path, success: "イベントへの参加を取り消しました"
    else
      redirect_to events_path, danger: "イベントへの参加取り消しを行えませんでした"
    end
  end
end
