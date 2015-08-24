namespace :dev do
  desc "Generate fake data"

  # 先做完 'db:schema:load'
  # 在做 :environment => 載入環境
  # 最後才執行 task
  task fakeup: ['db:schema:load', :environment] do
    20.times do |i|
      Product.create(
        name: "product no.#{i}", description: "description no.#{i}",
        price: (rand(10) + 1) * 50, stock: rand(91) + 10
      )
    end
    cart = Cart.create
    Product.all.sample(5).each do |product|
      cart.line_items.create product: product, unit_price: product.price, quantity: rand(4) + 1
    end


    paid_order = Order.create name: 'Tony', address: '􏰃􏰂', payment_method: 'Credit' 
    paid_order.line_items.create(product: Product.all.sample, unit_price: 123, quantity: 1)
    paid_order.trades.create paid: true
    unpaid_order = Order.create name: 'Jason', address: '􏰄􏰁', payment_method: 'ATM' 
    unpaid_order.line_items.create(product: Product.all.sample, unit_price: 456, quantity: 2)
    unpaid_order.trades.create paid: false

  end
end