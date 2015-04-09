require 'rails_helper'

RSpec.describe Household, :type => :model do

  before(:each) do
    @household = Household.create(:name => "Bacon")
    @user1 = User.create(:name => "Turtle1", :household_id => @household.id)
    @user2 = User.create(:name => "Turtle2", :household_id => @household.id)
    @user3 = User.create(:name => "Turtle3", :household_id => @household.id)
  end

  it "counts finds highest balance correctly" do

    Purchase.create(:name => "toothbrush", :price => 5, :user_id => @user1.id, :household_id => @household.id)
    Purchase.create(:name => "toothbrush1", :price => 5, :user_id => @user1.id, :household_id => @household.id)
    Purchase.create(:name => "toothbrush2", :price => 2, :user_id => @user2.id, :household_id => @household.id)
    Purchase.create(:name => "toothbrush3", :price => 2, :user_id => @user2.id, :household_id => @household.id)

    @household.highest_balance.should == 10.0
  end

  it "counts balances correctly" do
      Purchase.create(name: "toiletpaper", :price => 0, :user_id => @user1.id, :household_id => @household.id)
      Purchase.create(name: "toiletpaper", :price => 2, :user_id => @user2.id, :household_id => @household.id)
      Purchase.create(name: "toiletpaper", :price => 4, :user_id => @user3.id, :household_id => @household.id)
      @household.balances.should ==  [
                                        {:name=> "Turtle1", :balance=>-4.0},
                                        {:name=> "Turtle2", :balance=>-2.0},
                                        {:name=> "Turtle3", :balance=>0.0}
                                      ]
  end
  
end