require 'pry'
require 'faker'

module UserFactory
	
	def self.create_users number
		number = 50 unless number
		number.times do 
			User.create! email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, password: 'password', gender: [0, 1, 2].sample.to_i, interested_in: [0, 1, 2].sample.to_i, role: 2
		end
	end
end

