require 'rails_helper'

RSpec.describe Household, :type => :model do

  before(:each) do
    @household = Household.create(:id => 1, :name => "Bacon")
    @user1 = User.create(:name => "Turtle1", :household_id => @household.id)
    @user2 = User.create(:name => "Turtle2", :household_id => @household.id)
    @user3 = User.create(:name => "Turtle3", :household_id => @household.id)
  end

  it "counts finds highest balance correctly" do
    Purchase.create(:name => "toothbrush", :price => 5, :user_id => @user1.id, :household_id => @household.id)
    Purchase.create(:name => "toothbrush1", :price => 5, :user_id => @user1.id, :household_id => @household.id)
    Purchase.create(:name => "toothbrush2", :price => 2, :user_id => @user2.id, :household_id => @household.id)
    Purchase.create(:name => "toothbrush3", :price => 2, :user_id => @user2.id, :household_id => @household.id)
    @household.most_money_spent.should == 10.0
  end
end