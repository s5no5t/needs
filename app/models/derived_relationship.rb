class DerivedRelationship < ActiveRecord::Base
  belongs_to :derived_requirement, :class_name => 'Requirement'
  belongs_to :deriving_requirement, :class_name => 'Requirement'
end
