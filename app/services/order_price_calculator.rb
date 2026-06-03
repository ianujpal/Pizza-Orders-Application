class OrderPriceCalculator
  def initialize(order)
    @order = order
    @config = YAML.load_file(Rails.root.join("config/pizza_config.yml"))
  end

  def call
    subtotal = priced_items.sum { |entry| entry[:price] }
    subtotal -= promotion_savings
    apply_discount(subtotal).round(2)
  end

  private

  def priced_items
    @order.items.map do |item|
      { item: item, price: pizza_price(item) }
    end
  end

  def pizza_price(item)
    multiplier = @config["size_multipliers"][item["size"]]

    base_price = @config["pizzas"][item["name"]] * multiplier

    extras = Array(item["add"]).sum do |ingredient|
      @config["ingredients"][ingredient] * multiplier
    end

    base_price + extras
  end

  def promotion_savings
    Array(@order.promotion_codes).sum do |code|
      promo = @config["promotions"][code]
      next 0 unless promo

      prices = priced_items
        .select { |entry| matches_promotion?(entry[:item], promo) }
        .map { |entry| entry[:price] }
        .sort

      from = promo["from"]
      free_per_group = from - promo["to"]
      savings = 0

      prices.each_slice(from) do |group|
        next if group.size < from

        savings += group.sort.take(free_per_group).sum
      end

      savings
    end
  end

  def matches_promotion?(item, promo)
    item["name"] == promo["target"] && item["size"] == promo["target_size"]
  end

  def apply_discount(amount)
    code = @order.discount_code
    return amount if code.blank?

    discount = @config["discounts"][code]
    return amount unless discount

    percent = discount["deduction_in_percent"]
    amount * (100 - percent) / 100.0
  end
end
