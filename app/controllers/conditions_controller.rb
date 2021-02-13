class ConditionsController < ApplicationController
  
  include ItemScrapesConcern
  
  def index
    @conditions = Condition.where(user_id: params[:id])
    puts "---"
    puts @conditions
    puts "---"
    if !@conditions.nil? then
      @itemLinks  = ItemLink.includes(:condition).where(conditions: {user_id: current_user.id})
    end
    # conditionsテーブルとitemLinkテーブルを連結して、viewに渡すデータを割り出す
    # itemLinkのurlはcsv形式(nLink,site1,site2,...,url1,url2,...)なので、各々配列に直し、インスタンス変数に格納してviewに渡す
  end
  
  def new
    @condition = Condition.new
  end
  
  def create
    @condition = current_user.conditions.new(condition_params)
    if @condition.save
      @itemLink = ItemLink.new
      @itemLink.condition_id = @condition.id
      # 各アイテムの購入サイトリンク生成 (csv形式：nLink, site1name, site2name, ... , site1URL, site2URL, ...)
      @itemLink.camera       = set_item_link('camera+' + @condition.camera)
      @itemLink.lens         = set_item_link('lens+' + @condition.lens)
      @itemLink.telescope    = set_item_link('telescope+' + @condition.telescope)
      @itemLink.filter       = set_item_link('filter+' + @condition.filter)
      @itemLink.mount        = set_item_link('mount+' + @condition.mount)
      @itemLink.tripod       = set_item_link('tripod+' + @condition.tripod)
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
  
  def edit
    @condition = Condition.find(params[:id])
  end
  
  def update
    condition = Condition.find(params[:id])
    if condition.update(condition_params)
      redirect_to conditions_path, success: "撮影条件を更新しました"
    else
      flash.now[:danger] = "撮影情報を更新できませんでした"
    end
  end
  
  def destroy
    condition = Condition.find(params[:id])
    if condition.user_id == current_user.id
      if condition.destroy
        redirect_to conditions_path, success: "撮影条件の削除が完了しました"
      else
        flash.now[:danger] = "撮影条件の削除に失敗しました"
      end  
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
