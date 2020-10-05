class Rate < ApplicationRecord
  belongs_to :to_currency_symbol, class_name: 'CurrencySymbol', foreign_key: 'to_currency_symbol_id'
  belongs_to :from_currency_symbol, class_name: 'CurrencySymbol', foreign_key: 'from_currency_symbol_id'
  validates_presence_of :to_currency_symbol, :from, :to, :value
  validates_uniqueness_of :from, :scope => [:to]
end
