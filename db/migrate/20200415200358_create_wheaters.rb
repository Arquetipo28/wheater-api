class CreateWheaters < ActiveRecord::Migration[6.0]
  def change
    create_table :wheaters do |t|
      t.string :city
      t.float :temp

      t.timestamps
    end
  end
end
