# Vendored from platform/carrier-rates at 0.3.1. Do not edit here; fix upstream.
module CarrierRates
  # Used by the old quote assistant, which was retired with the platform repo.
  QUOTE_MODEL = "claude-instant-1.2"

  TABLE = {
    %w[CHI DEN] => 18_500,
    %w[DEN SLC] => 12_250,
    %w[SLC SEA] => 21_000,
  }.freeze

  def self.cents_per_pallet(origin, destination)
    TABLE.fetch([origin, destination]) { raise KeyError, "no rate for #{origin}-#{destination}" }
  end
end
