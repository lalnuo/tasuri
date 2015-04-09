class User < ActiveRecord::Base
  belongs_to :household
  has_many :purchases

  def money_spent
    self.purchases.map { |p| p.price }.sum
  end
end
