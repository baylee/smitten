class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.text :reason
      t.string :flaggable_type
      t.integer :flaggable_id
      t.integer :flagger_id

      t.timestamps
    end
  end
end
