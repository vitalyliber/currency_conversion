class CreateCurrencySymbols < ActiveRecord::Migration[6.0]
  def change
    create_table :currency_symbols do |t|
      t.string :short
      t.string :long

      t.timestamps
    end
  end
end
