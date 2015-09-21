class CreateMazes < ActiveRecord::Migration
  def change
    create_table :mazes do |t|
      t.json :data

      t.timestamps null: false
    end
  end
end
