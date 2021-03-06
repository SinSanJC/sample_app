# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#User admin
User.create!(name:  "adrian",
			email: "adrian@email.com",
			password:              "123456",
			password_confirmation: "123456",
			admin: true,
			activated: true,
			activated_at: Time.zone.now)

# Users
14.times do |n|
	name  = Faker::Name.name
	email = "example-#{n+1}@email.com"
	password = "123456"
	User.create!(name:  name,
				email: email,
				password: password,
				password_confirmation: password,
				activated: true,
				activated_at: Time.zone.now)
end

# Post
users = User.asc(:created_at).limit(6)

5.times do
	content = Faker::Lorem.sentence(5)
	users.each { |user| user.microposts.create!(content: content) }
end

# Following
users = User.all
user  = users.first
following = users[2..14]
followers = users[3..11]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }