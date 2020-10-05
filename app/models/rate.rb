class Rate < ApplicationRecord
  belongs_to :currency_symbol
  validates_presence_of :currency_symbol, :from, :to, :value
  validates_uniqueness_of :currency_symbol_id, :scope => [:from, :to]
end
