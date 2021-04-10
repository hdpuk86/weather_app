class CreateHeatRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :heat_ratings do |t|
      t.float :min_temp
      t.float :max_temp
      t.string :name

      t.timestamps
    end
  end
end
