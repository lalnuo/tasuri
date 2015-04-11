class Household < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :users
  has_many :purchases

  has_secure_password

  #TODO: don't update this every time user checks for balance
  def most_money_spent
    user = self.users.max_by { |user| user.money_spent }
    user ? user.money_spent : 0
  end

  def to_json(options)
    super(:only => [:name, :id], :include => {:users => {:methods => :balance}})
  end
end
