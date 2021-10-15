class AddDestinationToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :destination, :string
  end
end
