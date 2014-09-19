class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.integer :user_id, null: false
      t.string  :category, null: false
      t.string  :name, null: false
      t.integer :value, null: false
      t.timestamps
    end

    # TODO indexes
  end

  def self.down
    drop_table :preferences
  end
end