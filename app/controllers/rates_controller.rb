class RatesController < ApplicationController
  def index
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
    render json: {
             rates: rates_json['rates'], symbols: symbols_json['symbols']
           },
           status: :ok
  end
end
