plugins {
    java
    application
}

group = "com.fleetwise"
version = "2.4.0"

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

dependencies {
    implementation(libs.jackson.databind)
    implementation(libs.snakeyaml)
    implementation(libs.guava)
    implementation(libs.commons.text)

    testImplementation(libs.junit.jupiter)
    testRuntimeOnly(libs.junit.platform.launcher)
}

application {
    mainClass.set("com.fleetwise.inventory.App")
}

tasks.test {
    useJUnitPlatform()
}
