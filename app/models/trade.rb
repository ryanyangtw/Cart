require 'allpay'
class Trade < ActiveRecord::Base
  belongs_to :order

  serialize :params, JSON # 若接的postgtesql，不需加此行。可以用t.json 產生json型態的資料欄位

  # Lastly an after_find and after_initialize callback is triggered for each object that is found and instantiated by a finder, with after_initialize being triggered after new objects are instantiated as well.
  # before_create 也可以
  after_initialize :generate_trade_number, if: :new_record? 
  before_save :check_mac, unless: :new_record?

  def generate_trade_number
    num = ''
    loop do
      num = SecureRandom.hex(3)
      # exists 不會把物件load進來，效能比較好
      break unless Trade.exists? trade_number: num
    end
    self.trade_number = num
  end


  def self.find_and_initialize_by_allpay params = {}
    trade = self.find_by(trade_number: params[:MerchantTradeNo])
    trade.paid = params['RtnCode'] == '1'
    trade.params = params
    trade
  end

  def check_mac
    allpay = Allpay.new
    raise "Chec Mac Error" unless allpay.check_mac(self.params)
  end

end
