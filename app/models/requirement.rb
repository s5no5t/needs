class Requirement < ActiveRecord::Base
  attr_accessible :body, :title

  has_many :derived_relationships, :foreign_key => 'derived_requirement_id'
  has_many :derived_requirements, :through => :derived_relationships

  has_many :deriving_relationships, :class_name => 'DerivedRelationships', :foreign_key => 'deriving_requirement_id'
  has_many :derving_requirements, :through => :deriving_relationships
end
