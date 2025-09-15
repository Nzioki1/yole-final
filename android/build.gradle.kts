plugins {
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    // The Flutter Gradle Plugin must be applied after Android & Kotlin.
    id("dev.flutter.flutter-gradle-plugin") apply false
}

buildscript {
    dependencies {
        // Pair with Gradle wrapper 8.11.1 (below)
        classpath("com.android.tools.build:gradle:8.9.1")
    }
}