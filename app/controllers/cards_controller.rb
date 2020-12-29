class CardsController < ApplicationController
  
  require 'payjp'
  
  def new
    @card = Card.where(user_id: current_user.id)
    if @card.exists?
      redirect_to card_path
    end
  end
  
  def create    # payjpとCardのデータベース作成
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    
    @card = Card.find_by(user_id: current_user.id)
    if @card.present?
      destroy 
    end
      
    
    if params['payjp-token'].blank?    # payjp-tokenが空ならnewする
      flash.now[:danger] = "クレジットカードを登録できませんでした。入力値を確認してください。"
      render :new
    else    # payjp-tokenが無事に生成されたときのアクション
      # 生成されたpayjp-tokenから、ユーザ情報と紐づけて、payjpに登録
      customer = Payjp::Customer.create(
        description: 'クレジットカード登録',
        email: current_user.email,
        card: params['payjp-token'],
        metadata: {user_id: current_user.id}
      )
      # cardモデルへ登録
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, default_card_id: customer.default_card)
      if @card.save
        redirect_to card_path(current_user.id), success: "クレジットカードの登録が完了しました"
      else
        flash.now[:danger] = "クレジットカードの登録に失敗しました"
        render :new
      end
    end
  end
  
  def show    # CardのデータをPayjpに送り、情報を取り出す
    @card = Card.find_by(user_id: current_user.id)
    if @card.blank?
      redirect_to new_card_path
    else
      # API秘密鍵の呼び出し
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      # customer_idからpayjpに登録されているカスタマー情報を取り出し
      customer = Payjp::Customer.retrieve(@card.customer_id)
      # カスタマー情報からカード情報を抜き出し
      @customer_card = customer.cards.retrieve(@card.default_card_id)
      
      # カードアイコン表示のための定義づけ
      @card_brand = @customer_card.brand
      case @card_brand
      when "Visa"
        # 例えば、payjpからとってきたカード情報のブランドが"Visa"の場合、
        # 返り値として、（画像登録されている）Visa.pngを返す
        @card_src = "Visa.png"
      when "JCB"
        @card_src = "jcb.png"
      when "MasterCard"
        @card_src = "master.png"
      when "American Express"
        @card_src = "amex.png"
      when "Diners Club"
        @card_src = "diners.png"
      when "Discover"
        @card_src = "discover.png"
      end
      
      # viewの記述を簡略化
      ## 有効期限'月'を定義
      @exp_month = @customer_card.exp_month.to_s
      ## 有効期限'年'を定義
      @exp_year  = @customer_card.exp_year.to_s.slice(2,3)
    end
  end
  
  def destroy    # PayjpとCardのデータベース削除
    @card = Card.find_by(user_id: current_user.id)
    if @card.blank?
      redirect_to new_card_path
    else
      # API秘密鍵の呼び出し
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      # customer_idからpayjpに登録されているカスタマー情報を取り出し
      customer = Payjp::Customer.retrieve(@card.customer_id)
      # 取り出したカスタマー情報を削除
      customer.delete
      # cardモデルのデータも削除
      @card.delete
      # 削除が完了しているか判断
      if @card.destroy
        # 削除完了していれば、削除完了ページにリダイレクト
        ### redirect_to card_path, success: 'クレジットカード情報を削除しました'
      else
        # 削除されなかった場合、flashメッセージでshowのviewに移行
        flash.now[:danger] = 'クレジットカード情報の削除に失敗しました'
        render :show
      end
    end
  end
end
