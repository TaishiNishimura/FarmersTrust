class AddAddressIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :address_id, :integer
  end
end
