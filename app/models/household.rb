class Household < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :users
  has_many :purchases

  has_secure_password

  def highest_balance
    user = self.users.max_by { |user| user.money_spent }
    user ? user.money_spent : 0
  end

  def balances
    highest = highest_balance
    self.users.map { |user| {name: user.name, userBalance: user.money_spent - highest } }
  end

  def to_json(options)
    super(:only => :name, :methods => [:highest_balance, :balances], :include => [:users])
  end
end
