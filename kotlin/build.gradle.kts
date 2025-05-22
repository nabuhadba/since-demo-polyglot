plugins {
    kotlin("jvm") version "1.9.24"
    application
}

group = "com.fleetwise"
version = "0.7.0"

repositories {
    mavenCentral()
}

val ktorVersion = "2.3.4"

dependencies {
    // Ktor 2 migration in progress: the build files are on 2.x, the server code is not yet.
    implementation("io.ktor:ktor-server-core-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-netty-jvm:$ktorVersion")
    implementation("io.ktor:ktor-server-content-negotiation-jvm:$ktorVersion")
    implementation("io.ktor:ktor-serialization-jackson-jvm:$ktorVersion")
    implementation("com.squareup.okhttp3:okhttp:4.9.1")
    implementation("ch.qos.logback:logback-classic:1.2.11")

    testImplementation(kotlin("test"))
}

kotlin {
    jvmToolchain(17)
}

application {
    mainClass.set("com.fleetwise.notify.ApplicationKt")
}

tasks.test {
    useJUnitPlatform()
}
