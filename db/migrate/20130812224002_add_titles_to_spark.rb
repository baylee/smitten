class AddTitlesToSpark < ActiveRecord::Migration
  def change
    add_column :sparks, :input_location, :string
    add_column :sparks, :title, :string
  end
end
