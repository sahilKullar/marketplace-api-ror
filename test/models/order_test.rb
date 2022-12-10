require "test_helper"
class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
    @product_one = products(:one)
    @product_two = products(:two)
  end

  # test "should have a positive total" do
  #   @order.total = -1
  #   assert_not @order.valid?
  # end

  test "should set total" do
    order = Order.new user_id: @order.user_id
    order.products << products(:one)
    order.products << products(:two)
    order.save
    assert_equal (@product_one.price + @product_two.price), order.total
  end
end
