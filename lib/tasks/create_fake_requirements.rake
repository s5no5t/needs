namespace :db do
	desc "Create 100 fake requirements"
	task :create_fake_requirements => :environment do
		reqs = []

		100.times do |i|
			req = Requirement.new(:title => Faker::Lorem.sentence, 
							   	  :body => Faker::Lorem.paragraph)
			req.save
			reqs << req
		end

		200.times do |i|
			deriving_requirement = reqs[Random.rand(100)]
			derived_requirement = reqs[Random.rand(100)]

			deriving_requirement.derived_requirements << derived_requirement
		end

	end
end