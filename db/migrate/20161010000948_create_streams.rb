class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :name
      t.string :url
      t.string :title
      t.string :preview
      t.integer :viewers
      t.references :game, index: true

      t.timestamps
    end
  end
end
