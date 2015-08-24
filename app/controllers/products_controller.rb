class ProductsController < ApplicationController
  before_action :set_product, only: :show

  def index
    @products = Product.order(id: :asc)
  end

  def show
    @line_item = current_cart.line_items.find_or_initialize_by(product: @product)
  end


  private 
  def set_product
    @product = Product.find(params[:id])
  end

end
