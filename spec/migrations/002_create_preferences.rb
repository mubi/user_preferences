class CreatePreferences < (ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration)
  def self.up
    create_table :preferences do |t|
      t.integer :user_id, null: false
      t.string  :category, null: false
      t.string  :name, null: false
      t.integer :value, null: false
      t.timestamps null: false
    end

    add_index :preferences, :user_id
    add_index :preferences, [:user_id, :category]
    add_index :preferences, [:category, :name, :value]
  end

  def self.down
    drop_table :preferences
  end
end
