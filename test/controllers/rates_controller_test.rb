require 'test_helper'

class RatesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    # getting data from API and store to DB
    assert_equal Rate.count, 0
    assert_equal CurrencySymbol.count, 0
    get rates_path
    assert_response :success
    json = JSON.parse(body)
    assert_equal json['rates'].count, 168
    assert_equal Rate.count, 168
    assert_equal CurrencySymbol.count, 168
    assert_equal json['rates'][0]['to'], 'AED'
    assert_equal json['rates'][0]['from'], 'EUR'
    assert_equal json['rates'][0]['from_long'], 'Euro'
    assert_equal json['rates'][0]['to_long'], 'United Arab Emirates Dirham'
    # getting cached data from DB
    get rates_path
    assert_response :success
    json = JSON.parse(body)
    assert_equal json['rates'].count, 168
    assert_equal Rate.count, 168
    assert_equal CurrencySymbol.count, 168
    # getting fresh data after 12 hours
    Timecop.freeze(Time.now + 12.hours + 10.minutes) do
      get rates_path
      assert_response :success
      json = JSON.parse(body)
      assert_equal json['rates'].count, 168
      assert_equal Rate.count, 168
      assert_equal CurrencySymbol.count, 168
    end
  end

  test 'should get an error for index' do
    ENV['FIXER_IO_ACCESS_KEY'] = 'broken_key'
    get rates_path
    assert_response 400
    json = JSON.parse(body)
    assert_equal json['error'],
                 'Errors on the fixer.io API side (rates status: false, symbols_status: false)'
  end

  test 'verify n+1 issues' do
    populate = lambda do |number|
      number.times do |n|
        from = "EUR_#{n}"
        to = "AUD_#{n}"
        from_currency_symbol =
            CurrencySymbol.create!(short: from, long: "EUR_#{n}_long")
        to_currency_symbol =
            CurrencySymbol.create!(short: to, long: "AUD_#{n}_long")
        Rate.create!(
            to: to,
            from: from,
            to_currency_symbol: to_currency_symbol,
            from_currency_symbol: from_currency_symbol,
            value: rand(1..7)
        )
      end
    end

    assert_perform_constant_number_of_queries(populate: populate) do
      get rates_path
    end
  end
end
