# storefront

The customer portal's product API: catalog lookups, freight quotes, order webhooks, and the product
blurbs Claude drafts for the web team.

    bundle install
    bundle exec rake test
    bundle exec puma config.ru

Settings live in `config/settings.yml` (copy the example) and `.env` (copy `.env.example`); the
environment wins. The carrier rate tables are a vendored copy of the old platform gem.

TODO: CI. The Jenkins job went away with the old platform repo.
