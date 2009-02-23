class AddValueToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :price, :decimal, :precision => 10, :scale => 2, :null => false
  end

  def self.down
    remove_column :expenses, :price
  end
end
