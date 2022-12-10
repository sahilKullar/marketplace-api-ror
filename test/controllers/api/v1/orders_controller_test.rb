require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get api_v1_orders_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_order_url(@order)
    assert_response :success
  end

  test "should get create" do
    post api_v1_orders_url
    assert_response :success
  end
end
