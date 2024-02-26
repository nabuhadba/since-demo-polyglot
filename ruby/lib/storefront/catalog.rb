require "json"

module Storefront
  class Catalog
    def self.load(path)
      new(JSON.parse(File.read(path)))
    end

    def initialize(products)
      @by_sku = products.to_h { |product| [product.fetch("sku"), product] }
    end

    def find(sku)
      @by_sku[sku]
    end
  end
end
