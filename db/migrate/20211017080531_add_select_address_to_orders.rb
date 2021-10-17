class AddSelectAddressToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :select_address, :integer
  end
end
