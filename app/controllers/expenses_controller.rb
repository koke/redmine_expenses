class ExpensesController < ApplicationController
  unloadable
  
  def index
    if can_manage_expenses?
      @expenses = Expense.all
      @manager = true
    elsif can_have_expenses?
      @expenses = Expense.all.find(:all, :conditions => ["user_id = ? ", User.current.id])
    else
      render_403
    end
  end

  def new
    @expense = Expense.new(params[:expense])
    @expense.user_id = User.current.id
    if request.post?
      @expense.price = params[:expense][:price].gsub(',','.')
      if @expense.save
        flash[:notice] = l(:expenses_successful_update)
        redirect_to :controller => 'expenses', :action => 'index'
      else
        raise @expense.inspect
      end
    end
  end

  def edit
    unless request.post?
      render_403
      return
    end
    
    @expenses = Expense.find_all_by_id(params[:ids])
    if params[:delete]
      @expenses.each {|e| e.destroy }
      flash[:notice] = l(:expenses_deleted)
    elsif params[:pay] and can_manage_expenses?
      @expenses.each {|e| e.update_attribute(:paid, true) }
      flash[:notice] = l(:expenses_paid)
    elsif params[:unpay] and can_manage_expenses?
      @expenses.each {|e| e.update_attribute(:paid, false) }
      flash[:notice] = l(:expenses_unpaid)
    end
    
    redirect_to :controller => 'expenses', :action => 'index'
  end

  def report
    unless can_manage_expenses?
      render_403
      return
    end
    
    @expenses = Expense.unpaid
    @user_expenses = {}
    @expenses.each do |expense|
      @user_expenses[expense.username] ||= 0
      @user_expenses[expense.username] += expense.price
    end
  end  

private
  def can_have_expenses?
    User.current.allowed_to?(:manage_own_expenses, nil, :global => true)
  end
  
  def can_manage_expenses?
    User.current.allowed_to?(:manage_expenses, nil, :global => true) || User.current.admin?
  end
end
