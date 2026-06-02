# Pizza Orders Management

A Ruby on Rails application for managing pizza orders. The application displays open orders, calculates order totals (including promotions and discounts), and allows orders to be marked as completed.

## Features

* List all open pizza orders
* Display order details:

  * Order ID
  * Creation date
  * Pizza items
  * Added ingredients
  * Removed ingredients
  * Promotion codes
  * Discount codes
* Calculate order prices based on:

  * Pizza base prices
  * Size multipliers
  * Extra ingredients
  * Promotion codes
  * Discount codes
* Mark orders as completed
* Hide completed orders from the listing
* Automated test coverage with RSpec

---

## Technology Stack

* Ruby
* Ruby on Rails
* SQLite3
* RSpec
* RuboCop

---

## Prerequisites

* Ruby 3.2+
* Rails 7+
* Bundler

Verify installation:

```bash
ruby -v
rails -v
bundle -v
```

---

## Setup Instructions

### Clone Repository

```bash
git clone <repository_url>
cd pizza_orders
```

### Install Dependencies

```bash
bundle install
```

### Create Database

```bash
rails db:create
rails db:migrate
```

### Seed Sample Data

```bash
rails db:seed
```

### Start Server

```bash
rails server
```

Visit:

```text
http://localhost:3000
```

---

## Running Tests

Execute all tests:

```bash
bundle exec rspec
```

Run RuboCop:

```bash
bundle exec rubocop
```

---

## Price Calculation Rules

### Pizza Price

Pizza price is calculated as:

```text
(Base Pizza Price × Size Multiplier)
+
(Sum of Extra Ingredients × Size Multiplier)
```

### Size Multipliers

| Size   | Multiplier |
| ------ | ---------- |
| Small  | 0.7        |
| Medium | 1.0        |
| Large  | 1.3        |

### Pizza Base Prices

| Pizza      | Price |
| ---------- | ----- |
| Margherita | €5    |
| Salami     | €6    |
| Tonno      | €8    |

### Ingredient Prices

| Ingredient | Price |
| ---------- | ----- |
| Onions     | €1    |
| Cheese     | €2    |
| Olives     | €2.5  |


---

## Discounts

### SAVE5

* Reduces the final invoice amount by 5%

---

## API Endpoints

### List Orders

```http
GET /
```

### Complete Order

```http
PATCH /orders/:id
```

Marks an order as completed and removes it from the open orders list.

---

## Project Structure

```text
app/
├── controllers/
│   └── orders_controller.rb
├── models/
│   └── order.rb
├── services/
│   └── order_price_calculator.rb

config/
└── pizza_config.yml

spec/
├── requests/
│   └── orders_spec.rb
└── services/
    └── order_price_calculator_spec.rb
```

---

## Assumptions

* Orders are loaded from the provided JSON file.
* Completed orders are not displayed in the UI.
* Removed ingredients do not affect pricing.
* Extra ingredients are charged using the pizza size multiplier.
* Promotions are applied before percentage discounts.
* Prices are rounded to two decimal places.

---

## Future Improvements

* Import orders through an admin interface
* Add pagination
* Add authentication
* Add order search and filtering
* Improve UI styling
* Docker support

