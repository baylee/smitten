class CreateSparks < ActiveRecord::Migration
  def change
    create_table :sparks do |t|
      t.text :content
      t.float :latitude
      t.float :longitude
      t.references :user

      t.timestamps
    end
  add_index :sparks, :user_id
  end
end
