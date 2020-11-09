class AddNecessaryTables < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.string :random_num
      t.string :title
      t.integer :start
      t.string :link
      t.string :image
      t.timestamps null: false
    end

    create_table :agendas do |t|
      t.integer :meeting_id
      t.string :title
      t.integer :duration
      t.string :sentence
      t.timestamps null: false
    end
  end
end
