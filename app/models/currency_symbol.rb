class CurrencySymbol < ApplicationRecord
  has_many :rates
  validates_presence_of :short, :long
  validates_uniqueness_of :short, :long
end
