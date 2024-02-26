require "faraday"
require "json"
require "yaml"

module Storefront
  # Writes the marketing blurb for a product page. Someone on the web team edits every one.
  class Describer
    SETTINGS = YAML.safe_load(File.read(File.expand_path("../../config/settings.yml", __dir__)))

    # DEFAULT_MODEL = "claude-2.1"  # before the March 2024 switch
    DEFAULT_MODEL = "claude-3-5-haiku-20241022"

    def initialize(http: nil)
      @model = ENV["DESCRIBER_MODEL"] || SETTINGS.dig("describer", "model") || DEFAULT_MODEL
      @http = http || Faraday.new(url: "https://api.anthropic.com") do |f|
        f.request :json
        f.response :json
        f.adapter Faraday.default_adapter
      end
    end

    attr_reader :model

    def request_body(product)
      {
        model: @model,
        max_tokens: SETTINGS.dig("describer", "max_tokens") || 300,
        messages: [{ role: "user", content: "Write two sentences for a product page: #{product.to_json}" }],
      }
    end

    def describe(product)
      response = @http.post("/v1/messages", request_body(product)) do |req|
        req.headers["x-api-key"] = ENV.fetch("ANTHROPIC_API_KEY", "")
        req.headers["anthropic-version"] = "2023-06-01"
      end
      response.body.fetch("content").find { |block| block["type"] == "text" }&.fetch("text", "")&.strip
    end
  end
end
