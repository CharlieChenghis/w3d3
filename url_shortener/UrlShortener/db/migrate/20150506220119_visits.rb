class Visits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :short_url_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end

    add_index :visits, :user_id
    add_index :visits, :short_url_id
  end
end
