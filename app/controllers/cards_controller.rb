class CardsController < ApplicationController
  
  require 'payjp'
  before_action :set_card
  
  def new
  end
  
  def create    # payjpとCardのデータベース作成
    destroy if Card.find_by(user_id: current_user.id).present?    # 登録済み情報があったら削除
    
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    # ユーザ情報と紐づけてpayjpに登録
    customer = Payjp::Customer.create(
      email: current_user.email,
      card: params['payjp-token'],
      metadata: {user_id: current_user.id}
    )
    # cardモデルへ登録
    @card = Card.new(
      user_id: current_user.id,
      customer_id: customer.id,
      default_card_id: customer.default_card
    )
    @card.save
    redirect_to card_path(@card), success: "クレジットカードの登録が完了しました"
  end
  
  def show    # CardのデータをPayjpに送り、情報を取り出す
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']   # API秘密鍵の呼び出し
    customer = Payjp::Customer.retrieve(@card.customer_id)    # customer_idからpayjpに登録されているカスタマー情報を取り出し
    @customer_card = customer.cards.retrieve(@card.default_card_id)   # カスタマー情報からカード情報を抜き出し
    # カードアイコン表示のための定義づけ
    case @customer_card.brand
    when "Visa"
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
    # viewの記述を簡略化 (有効期限'月/年'を定義)
    @exp_month = @customer_card.exp_month.to_s
    @exp_year  = @customer_card.exp_year.to_s.slice(2,3)
  end
  
  def destroy    # PayjpとCardのデータベース削除
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']   # API秘密鍵の呼び出し
    customer = Payjp::Customer.retrieve(@card.customer_id)    # customer_idからpayjpに登録されているカスタマー情報を取り出し
    customer.delete   # 取り出したカスタマー情報を削除
    @card.destroy    # cardモデルのデータを削除
    redirect_to new_card_path, success: "クレジットカード情報を削除しました"
  end
  
  private
  def set_card
    @card = Card.find_by(user_id: current_user.id) if Card.find_by(user_id: current_user.id).present?
  end
end
