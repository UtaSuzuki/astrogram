class OrdersController < ApplicationController
  
  require 'payjp'
  
  def new
    @photo = Photo.find(params[:id])
    @author = User.joins(conditions: :photos).pluck("name")[@photo.id-1]
    
    if current_user.card.present?
      # API秘密鍵の呼び出し
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      # ユーザのカード情報を抜き出し
      @card = Card.find_by(user_id: current_user.id)
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
    # CardsControllerのshowメソッドの中身。以上 >>
  end
  
  def pay
    @photo = Photo.find(params[:photo_id])
    @author = User.joins(conditions: :photos).pluck("name")[@photo.id-1]
    
    # 購入テーブル登録済み商品は二重で購入されないようにする（2重決済の防止）
    if @photo.orders.find_by(user_id: current_user.id).present?
      redirect_to photo_path(@photo.id), info: "購入済みです"
    else
      # 同時に2人が購入した場合の、二重購入処理防止
      # API秘密鍵の呼び出し
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      @photo.with_lock do
        if current_user.card.present?
          # ユーザがクレジットカード登録済みの場合の処理
          # ユーザのクレジットカード情報を抜き出し
          @card = Card.find_by(user_id: current_user.id)
          # 登録カードでの決済処理
          @charge = Payjp::Charge.create(
            amount: @photo.price,
            customer: Payjp::Customer.retrieve(@card.customer_id),
            currency: 'jpy'
          )
        else
          # ユーザがクレジットカード未登録の場合の処理
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
            flash.now[:success] = "クレジットカードの登録が完了しました"
          else
            flash.now[:danger] = "クレジットカードの登録に失敗しました"
          end
          # APIの"Checkout"機能で決済処理を記述
          @charge = Payjp::Charge.create(
            amount: @photo.price,
            customer: Payjp::Customer.retrieve(@card.customer_id),
            currency: 'jpy'
          )
        end
        
        # 購入テーブルへの登録処理
        @order = Order.create(user_id: current_user.id, photo_id: @photo.id)
        if @order.save
          redirect_to photo_path(@photo.id), success: "購入が完了しました"
        else
          flash.now[:danger] = "購入に失敗しました"
          render :new
        end
      end
    end
  end
end
