class User < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :household
  has_many :purchases

  # TODO: if purchases size hasn't changed since last time don't count again
  def money_spent
    self.purchases.map { |p| p.price }.sum
  end

  def balance
    self.money_spent - self.household.most_money_spent
  end

  def to_json(options)
    super(:methods => [:balance])
  end
end
