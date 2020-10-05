class RatesController < ApplicationController
  def index
    last_order = Rate.order(updated_at: :asc).try :last
    if last_order && last_order.updated_at - (Time.now - 12.hours) > 0
      rates = Rate.all.order(to: :asc)
      symbols = CurrencySymbol.all.order(short: :asc)
    else
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
      rates_json['rates'].each do |el|
        to = el[0]
        symbol_object = symbols_json['symbols'].find {|el| el[0] === to}
        symbol_record = CurrencySymbol.find_or_create_by(
            short: symbol_object[0], long: symbol_object[1]
        )
        rate =
          Rate.find_or_create_by(from: rates_json['base'], to: to, currency_symbol: symbol_record)
        rate.update(value: el[1])
      end
      rates = Rate.all.order(to: :asc)
      symbols = CurrencySymbol.all.order(short: :asc)
    end

    render json: { rates: rates, symbols: symbols }, status: :ok
  end
end
