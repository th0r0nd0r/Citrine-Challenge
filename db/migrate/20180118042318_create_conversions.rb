class CreateConversions < ActiveRecord::Migration[5.1]
  def change
    create_table :conversions do |t|

      t.timestamps
    end
  end
end
