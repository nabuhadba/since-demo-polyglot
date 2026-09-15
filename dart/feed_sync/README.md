# feed_sync

Pulls each carrier's zipped rate feed and writes `out/<carrier>.csv` for the pricing job.

    dart pub get
    dart analyze
    dart test
    dart run feed_sync --carrier acme --url https://rates.example-carrier.com/feed.zip
