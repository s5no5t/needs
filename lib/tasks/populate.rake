namespace :db do
	desc "Create 100 fake requirements"
	task :populate => :environment do
		reqs = []

		100.times do |i|
			req = Requirement.new(:title => Faker::Lorem.sentence, 
							   	  :body => Faker::Lorem.paragraph)
			req.save
			reqs << req
		end

		50.upto 99 do |i|
			req = reqs[Random.rand(50)]
			req.derived_requirements << reqs[i]
			req.save
		end 

	end
end