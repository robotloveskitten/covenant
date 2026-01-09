class AddOrganizationToTasks < ActiveRecord::Migration[8.1]
  def change
    add_reference :tasks, :organization, foreign_key: true
  end
end
