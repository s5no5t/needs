class CreateDerivedRelationships < ActiveRecord::Migration
  def change
    create_table :derived_relationships do |t|
      t.references :deriving_requirement
      t.references :derived_requirement

      t.timestamps
    end

    remove_column :requirements, :derived_from_requirement_id
  end
end
