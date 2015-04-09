require 'rails_helper'

RSpec.describe User, :type => :model do

  before(:all) do
    @household = Household.create(:name => "Bacon")
    @user = User.create(:name => "Turtle", :household_id => @household.id)
  end
  
  it "counts money spent correctly" do
    purchase = Purchase.create(:price => 2.4, :user_id => @user.id, :household_id => @household.id)
    purchase = Purchase.create(:price => 2.5, :user_id => @user.id, :household_id => @household.id)
    @user.money_spent.should  == 4.9
  end
  
end