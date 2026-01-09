class AddOrganizationToTags < ActiveRecord::Migration[8.1]
  def change
    add_reference :tags, :organization, foreign_key: true
  end
end
