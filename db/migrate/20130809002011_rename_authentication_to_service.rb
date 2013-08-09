class RenameAuthenticationToService < ActiveRecord::Migration
  def change
    rename_table :authentications, :services
  end
end