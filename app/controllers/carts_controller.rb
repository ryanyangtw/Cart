class CartsController < ApplicationController
  
  def show
    @line_items = current_cart.line_items.order(id: :desc)
  end



end
