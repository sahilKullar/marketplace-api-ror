class Api::V1::OrdersController < ApplicationController
  before_action :check_login, only: %i[index show create]
  before_action :set_order, only: %i[show]
  def index
    render json: OrderSerializer.new(current_user.orders).serializable_hash.to_json
  end

  def show
    if @order
      options = { include: [:products] }
      render json: OrderSerializer.new(@order, options).serializable_hash.to_json
    else
      head :not_found
    end
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      OrderMailer.send_confirmation(@order).deliver
      render json: @order, status: :created
    else
      render json: { errors: @order.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:total, product_ids: [])
  end
end
