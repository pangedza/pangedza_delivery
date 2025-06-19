pluginManagement {
    repositories {
        google()
        gradlePluginPortal()
        mavenCentral()
    }
    plugins {
        id("com.android.application") version "7.4.2"
        id("kotlin-android") version "1.7.10"
        id("dev.flutter.flutter-gradle-plugin") version "1.0.0"
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") apply false
    id("kotlin-android") apply false
}

include(":app")
