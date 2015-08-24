require 'allpay'
class AllpayController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :check_ip
  before_action :set_trade

  def result
    if @trade.save
      redirect_to @trade.order, alert: '交易成功'
    else
      redirect_to @trade.order, alert: '交易失敗'
    end
  end

  def return
    if @trade.save
      render text: :'1|OK'
    else
      render text: :'0|ErrorMessage'
    end
  end


private

  def set_trade
    # request.POST 是最原始的資料
    # params 裡面預設會有 params[:action], params[:controller], params[:authenticity_token]
    @trade = Trade.find_and_initialize_by_allpay(request.POST)
  end

end