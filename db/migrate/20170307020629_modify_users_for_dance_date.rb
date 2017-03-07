class ModifyUsersForDanceDate < ActiveRecord::Migration
  def change
		add_column :users, :gender, :integer
		add_column :users, :role, :integer
		add_column :users, :picture, :string
  end
end
