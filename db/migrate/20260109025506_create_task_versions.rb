class CreateTaskVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :task_versions do |t|
      t.references :task, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.integer :version_number, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :task_versions, [ :task_id, :version_number ], unique: true
  end
end
