class CreateFish < ActiveRecord::Migration[5.2]
  def change
    create_table :fish do |t|
      t.string :fishname
      t.string :fishpass
      t.string :fishotp
      t.timestamps
    end
  end
end
