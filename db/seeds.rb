# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Create admin user"
unless User.where(email: "admin@teensdigest.com").first
  User.create!( email: "admin@teensdigest.com",
                password: "12345678",
                user_name: "duyllc",
                is_admin: true,
                confirmed_at: Time.now
              )
end

puts "Create advertise"
if Advertise.count == 0
  Advertise.create!
end
