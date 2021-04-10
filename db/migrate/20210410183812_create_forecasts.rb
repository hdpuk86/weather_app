class CreateForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :forecasts do |t|
      t.string :country
      t.string :postcode
      t.float :max_temp

      t.timestamps
    end
  end
end
