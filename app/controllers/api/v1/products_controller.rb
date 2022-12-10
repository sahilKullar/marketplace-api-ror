class Api::V1::ProductsController < ApplicationController
  include Paginable
  before_action :set_product, only: %i[show update destroy]
  before_action :check_login, only: %i[create]
  before_action :check_owner, only: %i[update destroy]

  def index
    @products = Product.page(current_page).per(per_page).search(params)
    options = get_links_serializer_options("api_v1_products_path", @products)
    render json: ProductSerializer.new(@products, options).serializable_hash.to_json
  end

  def show
    options = { include: [:user] }
    render json: ProductSerializer.new(@product, options).serializable_hash.to_json
  end

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      render json: ProductSerializer.new(@product).serializable_hash.to_json, status: :created
    else
      render json: { error: @product.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: ProductSerializer.new(@product).serializable_hash.to_json, status: :ok
    else
      render json: { error: @product.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def check_owner
    # head :forbidden unless current_user&.id == @product.user_id
    head :forbidden unless current_user == @product.user
  end
end
