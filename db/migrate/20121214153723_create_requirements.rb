class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :title
      t.text :body
      t.references :derived_from_requirement

      t.timestamps
    end
  end
end
