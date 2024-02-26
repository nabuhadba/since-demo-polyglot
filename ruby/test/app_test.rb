require "test_helper"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Storefront::App
  end

  def test_health
    get "/health"
    assert_equal 200, last_response.status
  end

  def test_product_lookup
    get "/products/PAL-48"
    assert_equal "Standard pallet, 48x40", JSON.parse(last_response.body)["name"]
    get "/products/NOPE"
    assert_equal 404, last_response.status
  end

  def test_quote_uses_the_vendored_rate_table
    get "/quote", from: "CHI", to: "DEN", pallets: "2"
    assert_equal 37_000, JSON.parse(last_response.body)["cents"]
  end

  def test_signed_webhook_is_accepted
    body = { order_id: "ORD-9" }.to_json
    post "/webhooks/orders", body, "HTTP_X_STOREFRONT_SIGNATURE" => Storefront::Signing.sign(body)
    assert_equal 202, last_response.status
    post "/webhooks/orders", body, "HTTP_X_STOREFRONT_SIGNATURE" => "forged"
    assert_equal 401, last_response.status
  end
end
