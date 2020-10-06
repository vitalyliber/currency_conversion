class RateSerializer < Blueprinter::Base
  fields :value, :id

  field :from_long do |object, options|
    object.from_currency_symbol.long
  end
  field :from do |object, options|
    object.from_currency_symbol.short
  end
  field :to_long do |object, options|
    object.to_currency_symbol.long
  end
  field :to do |object, options|
    object.to_currency_symbol.short
  end
end