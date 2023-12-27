class CreatePublishers < ActiveRecord::Migration[6.1]
  def change
    create_table :publishers do |t|
      t.string :name
      t.string :client_id

      t.timestamps
    end
  end
end
