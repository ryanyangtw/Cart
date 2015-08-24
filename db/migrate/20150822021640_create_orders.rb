class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :status, null: false, default: ''
      t.string :payment_method, null: false

      t.timestamps null: false
    end
  end
end
