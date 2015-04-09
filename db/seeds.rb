household = Household.create(name: "Lallin koti")
user = User.create(name: 'Lalli', household_id: household.id)
Purchase.create(household_id: household.id, user_id: user.id, name: 'Hammastahna', price: 2.5)
