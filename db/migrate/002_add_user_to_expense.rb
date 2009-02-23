class AddUserToExpense < ActiveRecord::Migration
  def self.up
    add_column :expenses, :user_id, :integer, :null => false
  end

  def self.down
    remove_column :expenses, :user_id
  end
end
