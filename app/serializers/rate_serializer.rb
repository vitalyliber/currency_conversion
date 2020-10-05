class RateSerializer < Blueprinter::Base
  fields :from, :to, :value

  field :from_long do |object, options|
    object.from_currency_symbol.long
  end
  field :to_long do |object, options|
    object.to_currency_symbol.long
  end
end