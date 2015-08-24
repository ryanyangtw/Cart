class Order < ActiveRecord::Base
  has_many :line_items
  has_many :products, through: :line_items
  has_many :trades

  after_create :consume_stock


  def total
    # toal = 0
    # self.line_items.each do |line_item|
    #   total += line_item.subtotal
    # end
    # total
    line_items.to_a.sum(&:subtotal)
    # line_item.to_a.sum{|i| i.subtotal}
  end

  def paid?
    # trades.find_by(paid: true).exists?
    trades.exists?(paid: true)
  end


  def self.new_from_cart cart, params = {}
    order = self.new params
    order.line_items = cart.line_items # 此行有寫入database
    order
  end


  private

  def consume_stock
    line_items.each do |line_item|
      line_item.product.stock -= line_item.quantity
      line_item.product.save!
    end
  end

end
