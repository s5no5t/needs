class Requirement < ActiveRecord::Base
  attr_accessible :body, :title, :derived_from_requirement_id

  belongs_to :derived_from_requirement, :class_name => 'Requirement', :foreign_key => 'derived_from_requirement_id'

  has_many :derived_requirements, :class_name => 'Requirement', :foreign_key => 'derived_from_requirement_id'
end
