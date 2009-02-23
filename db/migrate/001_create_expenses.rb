class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.column :description, :string
      t.column :paid, :boolean, :null => false, :default => false
      t.column :expense_date, :date, :null => false, :default => false
    end
  end

  def self.down
    drop_table :expenses
  end
end
