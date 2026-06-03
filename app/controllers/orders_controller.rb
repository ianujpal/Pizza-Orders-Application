class OrdersController < ApplicationController
  def index
    @orders = Order.where(state: "OPEN")
  end

  def update
    order = Order.find(params[:id])

    order.update!(state: "COMPLETED")

    redirect_to root_path
  end
end
