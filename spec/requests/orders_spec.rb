require "rails_helper"

RSpec.describe "Orders", type: :request do
  describe "GET /" do
    it "lists open orders" do
      open_order = Order.create!(
        order_id: "open-1",
        state: "OPEN",
        created_at_external: Time.zone.parse("2024-05-10T14:30:00Z"),
        items: [ { "name" => "Margherita", "size" => "Medium", "add" => [], "remove" => [] } ],
        promotion_codes: [],
        discount_code: nil
      )
      Order.create!(
        order_id: "done-1",
        state: "COMPLETED",
        created_at_external: Time.zone.parse("2024-05-11T14:30:00Z"),
        items: [ { "name" => "Salami", "size" => "Small", "add" => [], "remove" => [] } ],
        promotion_codes: [],
        discount_code: nil
      )

      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(open_order.order_id)
      expect(response.body).not_to include("done-1")
    end
  end

  describe "PATCH /orders/:id" do
    it "marks order completed" do
      order = Order.create!(
        order_id: "open-2",
        state: "OPEN",
        created_at_external: Time.zone.parse("2024-05-10T14:30:00Z"),
        items: [ { "name" => "Margherita", "size" => "Medium", "add" => [], "remove" => [] } ],
        promotion_codes: [],
        discount_code: nil
      )

      patch order_path(order)

      expect(response).to redirect_to(root_path)
      expect(order.reload.state).to eq("COMPLETED")
    end
  end
end
