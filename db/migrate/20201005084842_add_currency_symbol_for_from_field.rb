class AddCurrencySymbolForFromField < ActiveRecord::Migration[6.0]
  def change
    remove_index :rates, :currency_symbol_id
    remove_column :rates, :currency_symbol_id, :bigint
    add_column :rates, :to_currency_symbol_id, :bigint
    add_index :rates, :to_currency_symbol_id
    add_column :rates, :from_currency_symbol_id, :bigint
    add_index :rates, :from_currency_symbol_id
  end
end
