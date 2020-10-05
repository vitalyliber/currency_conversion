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
    assert_equal json['symbols'].count, 168
    assert_equal Rate.count, 168
    assert_equal CurrencySymbol.count, 168
    assert_equal json['rates'][0]['to'], 'AED'
    # getting cached data from DB
    get rates_path
    assert_response :success
    json = JSON.parse(body)
    assert_equal json['rates'].count, 168
    assert_equal json['symbols'].count, 168
    assert_equal Rate.count, 168
    assert_equal CurrencySymbol.count, 168
    assert_equal json['rates'][0]['to'], 'AED'
    # getting fresh data after 12 hours (see data in cassettes)
    Timecop.freeze(Time.now + 12.hours + 10.minutes) do
      get rates_path
      assert_response :success
      json = JSON.parse(body)
      assert_equal json['rates'].count, 168
      assert_equal json['symbols'].count, 168
      assert_equal Rate.count, 168
      assert_equal CurrencySymbol.count, 168
      assert_equal json['rates'][0]['to'], 'AED'
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
end
