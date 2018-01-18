class CreateConversions < ActiveRecord::Migration[5.1]
  def change
    create_table :conversions do |t|
      t.string :freedom_unit
      t.string :si_unit
      t.float :conversion_factor
      t.timestamps
    end
  end
end
