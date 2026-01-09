class CreateInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :invitations do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :invited_by, null: false, foreign_key: { to_table: :users }
      t.string :email, null: false
      t.string :token, null: false
      t.string :role, null: false, default: "member"
      t.datetime :accepted_at

      t.timestamps
    end
    add_index :invitations, :token, unique: true
    add_index :invitations, [:organization_id, :email], unique: true
  end
end
