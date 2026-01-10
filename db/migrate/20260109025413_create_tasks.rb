class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :content
      t.string :task_type, default: 'task'
      t.string :status, default: 'not_started'
      t.string :default_view, default: 'document'
      t.date :due_date
      t.integer :position, default: 0
      t.references :parent, foreign_key: { to_table: :tasks }
      t.references :assignee, foreign_key: { to_table: :users }
      t.references :creator, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :tasks, [ :parent_id, :position ]
    add_index :tasks, :task_type
    add_index :tasks, :status
  end
end
