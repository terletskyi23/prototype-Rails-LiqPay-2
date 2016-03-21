class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :title
      t.boolean :payed, default: false

      t.timestamps
    end
  end
end
