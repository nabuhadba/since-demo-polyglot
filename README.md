# fleetwise

Fleetwise's services. Each team's repo moved in here as its own folder; nothing is shared between
them except this README and the CI folder.

| Folder | What it is | Stack | CI |
| --- | --- | --- | --- |
| `rust/` | manifest-tools: checks carrier shipping manifests | Rust, Cargo workspace | yes |
| `ruby/` | storefront: the portal's product API | Ruby, Sinatra | no |
| `dotnet/` | Ledger: the billing ledger API and its library | .NET, ASP.NET Core | yes |
| `dotnet/reports-worker/` | nightly receivables report (internal feed) | .NET worker | no |
| `php/` | invoices: totals, invoice HTML, cover emails | PHP, Laravel-style layout | yes |
| `dart/feed_sync/` | pulls carriers' zipped rate feeds | Dart CLI | no |
| `dart/driver_app/` | the Android driver app | Flutter | no |
| `swift/tracking-server/` | latest scan per shipment for the portal | Swift, SwiftNIO (Linux) | yes |
| `swift/DriverKit/` | shared code of the iPhone driver app | Swift, UIKit (iOS only) | no |
| `elixir/` | dispatch: assigns loads to trucks | Elixir, Plug and Cowboy | yes |
| `java-gradle/` | inventory: stock levels and the reorder report | Java, Gradle | yes |
| `java-maven/` | billing-export: nightly CSV for accounting | Java, Maven | no |
| `kotlin/` | notify: customer delay notices | Kotlin, Ktor (mid-migration) | no |

Each folder's README says how to build and test it. CI runs on pull requests only, one workflow per
project in `.github/workflows/`, and only when that project's files change.

Copy each project's `.env.example` (or settings example) before running it locally. No real keys
live in this repo.
