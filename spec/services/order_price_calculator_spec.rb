require "rails_helper"

RSpec.describe OrderPriceCalculator do
  def build_order(items:, promotion_codes: [], discount_code: nil)
    Order.new(
      items: items,
      promotion_codes: promotion_codes,
      discount_code: discount_code
    )
  end

  it "calculates normal order price" do
    order = build_order(
      items: [
        { "name" => "Margherita", "size" => "Medium", "add" => [ "Cheese" ], "remove" => [] }
      ]
    )

    # Margherita Medium: 5 + Cheese: 2 = 7
    expect(described_class.new(order).call).to eq(7)
  end

  it "applies promotion" do
    order = build_order(
      items: [
        { "name" => "Salami", "size" => "Small", "add" => [], "remove" => [] },
        { "name" => "Salami", "size" => "Small", "add" => [ "Onions" ], "remove" => [] }
      ],
      promotion_codes: [ "2FOR1" ]
    )

    # Salami Small: 4.2 + 4.9 = 9.1, 2FOR1 frees cheapest (4.2) => 4.9
    expect(described_class.new(order).call).to eq(4.9)
  end

  it "applies discount" do
    order = build_order(
      items: [
        { "name" => "Tonno", "size" => "Large", "add" => [ "Olives", "Onions" ], "remove" => [] }
      ],
      discount_code: "SAVE5"
    )

    # Tonno Large: 10.4 + Olives: 3.25 + Onions: 1.3 = 14.95, 5% off => 14.20
    expect(described_class.new(order).call).to eq(14.20)
  end

  it "applies promotion and discount together" do
    order = build_order(
      items: [
        { "name" => "Salami", "size" => "Small", "add" => [], "remove" => [] },
        { "name" => "Salami", "size" => "Small", "add" => [ "Onions" ], "remove" => [] }
      ],
      promotion_codes: [ "2FOR1" ],
      discount_code: "SAVE5"
    )

    # After 2FOR1: 4.9, SAVE5: 4.9 * 0.95 => 4.65 (rounded)
    expect(described_class.new(order).call).to eq(4.65)
  end
end
