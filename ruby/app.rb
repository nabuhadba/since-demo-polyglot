require "sinatra/base"
require "json"
require "dotenv/load"
require "carrier_rates"
require_relative "lib/storefront/catalog"
require_relative "lib/storefront/describer"
require_relative "lib/storefront/signing"

module Storefront
  class App < Sinatra::Base
    set :server, :puma
    set :show_exceptions, false

    configure do
      set :catalog, Catalog.load(File.join(__dir__, "config", "catalog.json"))
      set :describer, Describer.new
    end

    before do
      content_type :json
    end

    get "/health" do
      { ok: true }.to_json
    end

    get "/products/:sku" do
      product = settings.catalog.find(params[:sku]) or halt 404, { error: "unknown sku" }.to_json
      product.to_json
    end

    get "/quote" do
      cents = CarrierRates.cents_per_pallet(params.fetch("from"), params.fetch("to"))
      pallets = Integer(params.fetch("pallets", "1"))
      { cents: cents * pallets }.to_json
    rescue KeyError, ArgumentError => e
      halt 422, { error: e.message }.to_json
    end

    post "/products/:sku/description" do
      product = settings.catalog.find(params[:sku]) or halt 404, { error: "unknown sku" }.to_json
      { sku: product["sku"], description: settings.describer.describe(product) }.to_json
    end

    post "/webhooks/orders" do
      body = request.body.read
      halt 401, { error: "bad signature" }.to_json unless Signing.valid?(body, request.env["HTTP_X_STOREFRONT_SIGNATURE"])
      status 202
      { accepted: JSON.parse(body).fetch("order_id") }.to_json
    end

    run! if app_file == $PROGRAM_NAME
  end
end
