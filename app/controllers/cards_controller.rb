class CardsController < ApplicationController
  
  require 'payjp'
  
  def new
    @card = Card.where(user_id: current_user.id)
    if card.exists? then
      redirect_to action: 'show'
    end
  end
  
  def create    # payjpとCardのデータベース作成
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    
    if params['payjp-token'].blank? then    # payjp-tokenが空ならnewする
      redirect_to action: 'new'
    else
      # payjpに登録するユーザを定義
      customer = Payjp::Customer.create(
        description: 'クレジットカード登録',
        email: current_user.email,
        card: params['payjp-token'],
        metadata: {user_id: current_user.id}
      )
      # cardモデル登録
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, default_card_id: customer.default_card)
      if @card.save then
        redirect_to action: 'show', success: "アカウント登録が完了しました"
      else
        redirect_to action: 'create'
      end
    end
  end
  
  def destroy    # PayjpとCardのデータベース削除
    @card = Card.find_by(user_id: current_user.id).first
    if card.blank? then
      redirect_to action: 'new'
    else
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      customer = Payjp::Customer.retrieve(card.customer_id)
      customer.delete
      card.delete
    end
  end
  
  def show    # CardのデータをPayjpに送り、情報を取り出す
    @card = Card.find_by(user_id: current_user.id).first
    if card.blank? then
      redirect_to action: 'new'
    else
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.default_card_id)
    end
  end
end
