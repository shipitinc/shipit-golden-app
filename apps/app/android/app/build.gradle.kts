plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Environment flavors shared with the Flutter `FLAVOR` dart-define.
//
// Every shipit-style app MUST keep these three flavors in sync with
// lib/core/config/app_flavor.dart and the iOS schemes.
val flavorApplicationIds = mapOf(
    "development" to "io.letsshipit.golden",
    "qa"          to "io.letsshipit.golden.qa",
    "production"  to "io.letsshipit.golden.production",
)

android {
    namespace = "io.letsshipit.golden"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "io.letsshipit.golden"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"

    productFlavors {
        create("development") {
            dimension = "environment"
            applicationId = flavorApplicationIds.getValue("development")
        }
        create("qa") {
            dimension = "environment"
            applicationId = flavorApplicationIds.getValue("qa")
        }
        create("production") {
            dimension = "environment"
            applicationId = flavorApplicationIds.getValue("production")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
