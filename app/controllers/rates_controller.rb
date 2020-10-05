class RatesController < ApplicationController
  def index
    last_order = Rate.order(updated_at: :asc).try :last
    unless last_order && last_order.updated_at - (Time.now - 12.hours) > 0
      rates_response =
        Faraday.get "http://data.fixer.io/api/latest?access_key=#{
                      ENV['FIXER_IO_ACCESS_KEY']
                    }&format=1"
      symbols_response =
        Faraday.get "http://data.fixer.io/api/symbols?access_key=#{
                      ENV['FIXER_IO_ACCESS_KEY']
                    }"
      begin
        rates_json = JSON.parse(rates_response.body)
        symbols_json = JSON.parse(symbols_response.body)
      rescue => e
        return(
          render json: { error: "Error while parsing json #{e.message}" },
                 status: :bad_request
        )
      end
      unless rates_json.dig('success') && symbols_json.dig('success')
        return(
          render json: {
                   error:
                     "Errors on the fixer.io API side (rates status: #{
                       rates_json.dig('success')
                     }, symbols_status: #{symbols_json.dig('success')})"
                 },
                 status: :bad_request
        )
      end
      from = rates_json['base']
      from_symbol_object =
          symbols_json['symbols'].find { |el| el[0] === from }
      from_symbol_record =
          CurrencySymbol.find_or_initialize_by(short: from_symbol_object[0])
      if from_symbol_record.long != from_symbol_object[1]
        from_symbol_record.update!(long: from_symbol_object[1])
      end
      rates_json['rates'].each do |el|
        to = el[0]
        to_symbol_object = symbols_json['symbols'].find { |el| el[0] === to }
        to_symbol_record =
          CurrencySymbol.find_or_initialize_by(short: to_symbol_object[0])

        if to_symbol_record.long != to_symbol_object[1]
          to_symbol_record.update!(long: to_symbol_object[1])
        end

        rate =
          Rate.find_or_create_by(
            from: from,
            to: to,
            to_currency_symbol: to_symbol_record,
            from_currency_symbol: from_symbol_record
          )
        rate.update(value: el[1])
      end
    end
    rates = Rate.all.order(to: :asc)

    render json: { rates: RateSerializer.render_as_hash(rates) }, status: :ok
  end
end
