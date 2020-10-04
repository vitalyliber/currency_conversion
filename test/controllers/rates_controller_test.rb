require 'test_helper'

class RatesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get rates_path
    assert_response :success
    json = JSON.parse(body)
    assert_equal json['rates'].count, 168
    assert_equal json['symbols'].count, 168
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
