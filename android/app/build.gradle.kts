plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")    // modern Kotlin plugin id
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.yolepesa.yolefinal"   // <- update to your final namespace
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.yolepesa.yolefinal"  // <- update appId
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
        release {
            // Turn off shrinking for now; add rules and re-enable later if needed
            minifyEnabled = false
            shrinkResources = false
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")

            // TEMP signing so `flutter run --release` works;
            // replace with your release keystore before publishing
            signingConfig = signingConfigs.getByName("debug")
        }
        debug {
            // example debug customizations if needed:
            // applicationIdSuffix = ".debug"
            // debuggable = true
        }
    }

    // (Optional) If you run into duplicate META-INF entries from some libs, uncomment:
    // packaging {
    //     resources {
    //         excludes += [ "META-INF/DEPENDENCIES", "META-INF/NOTICE", "META-INF/NOTICE.txt", "META-INF/LICENSE", "META-INF/LICENSE.txt" ]
    //     }
    // }
}

flutter {
    source = "../.."
}

// (Optional) If you need explicit stdlib (usually not necessary):
// dependencies {
//     implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.24"
// }
