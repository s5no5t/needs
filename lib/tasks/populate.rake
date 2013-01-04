namespace :db do
	desc "Create 100 fake requirements"
	task :populate => :environment do
	100.times do |i|
			Requirement.create(:title => Faker::Lorem.sentence, 
							   :body => Faker::Lorem.paragraph)
		end
	end
end