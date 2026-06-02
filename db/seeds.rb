# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

json = JSON.parse(
  File.read(Rails.root.join("data/orders.json"))
)

json.each do |order|
  record = Order.find_or_initialize_by(order_id: order["id"])
  record.assign_attributes(
    state: order["state"],
    created_at_external: order["createdAt"],
    items: order["items"],
    promotion_codes: order["promotionCodes"],
    discount_code: order["discountCode"]
  )
  record.save!
end
