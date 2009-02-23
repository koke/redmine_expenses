class Expense < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :user_id, :expense_date, :price
  validates_length_of :description, :maximum => 255, :allow_nil => true  

  named_scope :all, :order => 'paid ASC, expense_date DESC'
  named_scope :paid, :conditions => ['paid = ?', true], :order => 'expense_date DESC'
  named_scope :unpaid, :conditions => ['paid = ?', false], :order => 'expense_date DESC'
    
  def validate
    if self.expense_date.nil? && @attributes['expense_date'] && !@attributes['expense_date'].empty?
      errors.add :expense_date, :activerecord_error_not_a_date
    end    
  end
  
  def username
    # FIXME: hack,hack,hack bizarre engines behaviour
    User.find(user_id).name
  end
  
private
  def set_default_values
    self.paid ||= false
  end
end
