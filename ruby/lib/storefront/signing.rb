require "base64"
require "openssl"

module Storefront
  # Order webhooks from the portal are signed with a shared secret: base64(HMAC-SHA256(body)).
  module Signing
    module_function

    def secret
      ENV.fetch("WEBHOOK_SECRET", "")
    end

    def sign(body)
      Base64.strict_encode64(OpenSSL::HMAC.digest("SHA256", secret, body))
    end

    def valid?(body, signature)
      return false if signature.nil? || secret.empty?

      expected = sign(body)
      expected.bytesize == signature.bytesize && OpenSSL.fixed_length_secure_compare(expected, signature)
    end
  end
end
