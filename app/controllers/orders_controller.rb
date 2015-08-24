require 'allpay'

class OrdersController < ApplicationController

  def new
    @order = Order.new
  end

  def show
    @order = Order.find params[:id]
  end

  def create
    @order = Order.new_from_cart(current_cart, order_params)
    if @order.save
      current_cart.clear
      redirect_to @order
    else
      render :new
    end
  end

  def checkout
    @order = Order.find params[:id]
    if @order.paid?
      redirect_to @order, alert: '已經付過款'
    else
      trade = @order.trades.create!
      allpay = Allpay.new
      @checkout_params = {
        MerchantID: allpay.merchant_id,
        MerchantTradeNo: trade.trade_number,
        MerchantTradeDate: Time.now.strftime('%Y/%m/%d %H:%M:%S'),
        PaymentType: :aio,
        TotalAmount: @order.total.round,
        TradeDesc: :'My Cart',
        ItemName: @order.line_items.map{ |i| "#{i.product.name} x #{i.quantity}" }.join('#'),
        ChoosePayment: @order.payment_method,
        ReturnURL: allpay_return_url, #'http://requestb.in/1mo6blq1',
        OrderResultURL: allpay_result_url
        # ClientBackURL: '127.0.0.1.xip.io:3000'
      }
      @checkout_params[:CheckMacValue] = allpay.make_mac(@checkout_params)
    end
  end


  private
  def order_params
    params.require(:order).permit(:name, :address, :payment_method)
  end

end
