class ConditionsController < ApplicationController
  def index
    @conditions = Condition.where(user_id: current_user.id)
  end
  
  def new
    @condition = Condition.new
  end
  
  def create
    @condition = current_user.conditions.new(condition_params)
    if @condition.save
      redirect_to conditions_path, success: '撮影情報の登録に成功しました'
    else
      flash.now[:danger] = '撮影情報の登録に失敗しました'
      render :new
    end
  end
  
  private
  def condition_params
    params.require(:condition).permit(:title, :camera, :lens, :telescope, :filter, :mount, :tripod, :description)
  end
end
