class AddLocationToSpark < ActiveRecord::Migration
  def change
    add_column :sparks, :location_only, :boolean, :default => false
  end
end
