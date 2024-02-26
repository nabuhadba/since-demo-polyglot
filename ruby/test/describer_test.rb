require "test_helper"

class DescriberTest < Minitest::Test
  def test_request_uses_the_configured_model
    describer = Storefront::Describer.new(http: Object.new)
    body = describer.request_body({ "sku" => "PAL-48" })
    assert_equal describer.model, body[:model]
    assert_equal 300, body[:max_tokens]
  end

  def test_reads_the_text_block
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.post("/v1/messages") { [200, { "Content-Type" => "application/json" }, { content: [{ type: "text", text: " A sturdy pallet. " }] }.to_json] }
    end
    http = Faraday.new(url: "https://api.anthropic.com") do |f|
      f.request :json
      f.response :json
      f.adapter :test, stubs
    end
    assert_equal "A sturdy pallet.", Storefront::Describer.new(http: http).describe({ "sku" => "PAL-48" })
  end
end
