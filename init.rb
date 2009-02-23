require 'redmine'

Redmine::Plugin.register :redmine_expenses do
  name 'Expenses plugin'
  author 'Jorge Bernal'
  description 'A plugin for managing employees expenses'
  version '0.1'
  
  menu :account_menu, :expenses, { :controller => 'expenses', :action => 'index' }, :caption => 'Expenses', :before => :my_account, :if => Proc.new { User.current.logged? }
  
  project_module :expenses do
    permission :manage_expenses, :expenses => :admin
    permission :manage_own_expenses, :expenses => [:new, :edit, :destroy, :index]
  end
end