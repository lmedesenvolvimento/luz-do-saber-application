class CreateGroupsParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :groups_participants do |t|
      t.integer :type, default: 0, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :group, foreign_key: true, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
