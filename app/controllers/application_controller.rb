class ApplicationController < ActionController::API
  include Authenticable
  before_action :current_user
end
