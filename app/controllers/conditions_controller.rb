class ConditionsController < ApplicationController
  
  include ItemScrapesConcern
  
  def index
    @conditions = Condition.where(user_id: current_user.id)
  end
  
  def new
    @condition = Condition.new
  end
  
  def create
    @condition = current_user.conditions.new(condition_params)
    if @condition.save
      @itemLink = ItemLink.new
      @itemLink.condition_id = @condition.id
      @itemLink.camera       = set_item_link(@condition.camera)
      @itemLink.lens         = set_item_link(@condition.lens)
      @itemLink.telescope    = set_item_link(@condition.telescope)
      @itemLink.filter       = set_item_link(@condition.filter)
      @itemLink.mount        = set_item_link(@condition.mount)
      @itemLink.tripod       = set_item_link(@condition.tripod)
      if @itemLink.save
        redirect_to conditions_path, success: '撮影情報の登録に成功しました'
      else
        flash.now[:danger] = '撮影機器のリンク取得に失敗しました'
      end
    else
      flash.now[:danger] = '撮影情報の登録に失敗しました'
      render :new
    end
  end
  
  private
  def condition_params
    params.require(:condition).permit(
      :title, :camera, :lens, :telescope, :filter, :mount, :tripod, :description,
      itemLink_attributes: [:camera, :lens, :telescope, :filter, :mount, :tripod]
    )
  end
end
