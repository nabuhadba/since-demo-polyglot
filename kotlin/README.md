# notify

Sends customers delay notices through their webhooks, with a message Claude drafts.

**Mid-migration from Ktor 1 to Ktor 2: `./gradlew build` does not pass yet.** The build file and
`Routes.kt` are on Ktor 2; `Application.kt` still uses the Ktor 1 packages.

    ./gradlew build
    ./gradlew run
