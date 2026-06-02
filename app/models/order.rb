class Order < ApplicationRecord
  serialize :items, coder: JSON
  serialize :promotion_codes, coder: JSON

  def total_price
    OrderPriceCalculator.new(self).call
  end
end
