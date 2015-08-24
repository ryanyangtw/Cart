class Cart < ActiveRecord::Base
  has_many :line_items
  delegate :empty?, :clear, to: :line_items

  def total
    # total = 0
    # self.line_items.each do |line_item|
      
    #   # 不應該在Cart內命令lineItem做事，權責應該要分開清楚
    #   # total += line_item.unit_price * line_item.quantity
    #   total += line_item.subtotal
    # end
    # total

    line_items.to_a.sum(&:subtotal)
  end


  # Using delgate to replace below
  # def empty?
  #   # line_items.size == 0
  #   line_items.empty?
  # end

  # def clear
  #   line_itmes.clear
  # end

end
