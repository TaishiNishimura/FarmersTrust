class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_cart_items, only: [:new, :confirm, :create, :error]

  def new
    @order = Order.new
  end

  def confirm
    @order = Order.new(order_params)
    @select_address = params[:order][:select_address]
    if @select_address == '0'
      @order.get_shipping_informations_from(current_customer)
    elsif @select_address == '1'
      @selected_address = current_customer.addresses.find(params[:address_id])
      @order.get_shipping_informations_from(@selected_address)
    elsif @select_address == '2' && (@order.postal_code =~ /\A\d{7}\z/) && @order.destination? && @order.name?
      # 処理なし
    else
      flash[:error] = '情報を正しく入力して下さい。'
      render :new
    end
    @token = params[:order][:token]
  end

  def error
  end

  def create
    @order = current_customer.orders.new(order_params)
    @order.shipping_cost = 800
    @order.grand_total = @order.shipping_cost + @cart_items.sum(&:subtotal)
    if @order.save
      @order.create_order_details(current_customer)
      redirect_to thanks_path
    else
      render :new
    end
    Payjp.api_key = ENV['PAYJP_SECRET_KEY'] # PAY.JPに秘密鍵をセット
    Payjp::Charge.create( # PAY.JPに購入価格と顧客id、通過の種類を渡す
      amount: @order.grand_total,
      card: params[:order][:token],
      currency: 'jpy'
    )

  end

  def thanks
  end

  def index
    @orders = current_customer.orders.includes(:order_details, :items).page(params[:page]).reverse_order
  end

  def show
    @order = current_customer.orders.find(params[:id])
    @order_details = @order.order_details.includes(:item)
  end

  private

  def order_params
    params.require(:order).permit(:postal_code, :destination, :name, :payment_method, :token, :select_address, :address_id)
  end

  def ensure_cart_items
    @cart_items = current_customer.cart_items.includes(:item)
    redirect_to items_path unless @cart_items.first
  end
end
