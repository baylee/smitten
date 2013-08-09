class AddOauthtokenServices < ActiveRecord::Migration
  def change
    add_column :services, :oauth_token, :string
  end
end
