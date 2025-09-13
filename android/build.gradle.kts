plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")version "1.9.24" apply false
    // The Flutter Gradle Plugin must be applied after Android & Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.yolepesa.yolefinal"        // <- your final package
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.yolepesa.yolefinal"// <- app id
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    // AGP 8 requires Java 17
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        getByName("release") {
            // Keep shrinking OFF until everything builds; add rules later then flip these.
            isMinifyEnabled = false
            isShrinkResources = false

            // Temporary signing with debug so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
        // getByName("debug") { /* optional debug tweaks */ }
    }

    // If you hit META-INF duplicate resource issues, uncomment:
    // packaging {
    //     resources {
    //         excludes += setOf(
    //             "META-INF/DEPENDENCIES",
    //             "META-INF/NOTICE*",
    //             "META-INF/LICENSE*"
    //         )
    //     }
    // }
}

flutter {
    source = "../.."
}

// Usually not needed, but harmless if you want it explicit:
// dependencies {
//     implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.24")
// }


buildscript {
    dependencies {
        // Pair with Gradle wrapper 8.7 (below)
        classpath("com.android.tools.build:gradle:8.5.2")
    }
}

// Centralize Kotlin plugin version here (Kotlin DSL style)
plugins {
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false
}



