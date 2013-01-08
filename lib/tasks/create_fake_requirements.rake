task :log => :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

namespace :db do
	desc "Create 100 fake requirements"
	task :create_fake_requirements => :environment do
		reqs = []

		100.times do |i|
			requirement = Requirement.new(:title => Faker::Lorem.sentence, 
									   	  :body => Faker::Lorem.paragraph)
			requirement.save
			reqs << requirement

			if(i > 0) then
				deriving_requirement = reqs[Random.rand(i)]
				add_derived_relationship deriving_requirement, requirement
			end

			if(i > 10 and Random.rand(5) == 0) then
				deriving_requirement = reqs[Random.rand(i)]
				add_derived_relationship deriving_requirement, requirement
			end
		end

	end

	def add_derived_relationship(deriving_requirement, derived_requirement)
		deriving_relationship = deriving_requirement.derived_relationships.build
		deriving_relationship.derived_requirement = derived_requirement
		deriving_relationship.save
	end
end