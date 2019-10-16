class CreateUsers < (ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration)
  def self.up
    create_table :users do |t|
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :users
  end
end
