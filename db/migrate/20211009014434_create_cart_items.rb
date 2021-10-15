class CreateCartItems < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_items do |t|

      t.timestamps
      t.integer :item_id
      t.integer :customer_id
      t.integer :amount
    end
  end
end
