class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :order_id
      t.string :state
      t.datetime :created_at_external
      t.text :items
      t.text :promotion_codes
      t.string :discount_code

      t.timestamps
    end
  end
end
