require "test_helper"

class Api::V1::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    @order_params = { total: 50, product_ids: [orders(:one).id, orders(:two).id] }
  end

  test "should forbid orders for unlogged" do
    get api_v1_orders_url
    assert_response :forbidden
  end

  test "should get index" do
    get api_v1_orders_url, headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal @order.user.orders.count, json_response["data"].count
  end

  test "should show order" do
    get api_v1_order_url(@order), headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) }, as: :json
    assert_response :success
    json_response = JSON.parse(response.body, symbolize_names: true)
    assert_equal @order.products.first.title, json_response.dig(:included, 0, :attributes, :title)
  end

  test "should forbid create order for unlogged" do
    post api_v1_orders_url
    assert_response :forbidden
  end

  test "should create order with two products" do
    assert_difference("Order.count", 1) do
      # params: { order: { total: @order.total, product_ids: @order.products.ids } }
      post api_v1_orders_url, params: @order_params,
                              headers: { Authorization: JsonWebToken.encode(user_id: @order.user_id) }, as: :json
    end
    assert_response :created
  end
end
