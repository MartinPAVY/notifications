plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.notify_me"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        val dartEnvironmentVariables = mutableMapOf<String, String>()
        if (project.hasProperty("dart-defines")) {
            val dartDefinesProperty = project.property("dart-defines") as String
            val defines = dartDefinesProperty.split(",")
            for (define in defines) {
                val decoded = String(java.util.Base64.getDecoder().decode(define))
                val pair = decoded.split("=", limit = 2)
                if (pair.size == 2) {
                    dartEnvironmentVariables[pair[0]] = pair[1]
                }
            }
        }

        val appId = dartEnvironmentVariables["APP_ID"] ?: "com.example.notify_me"
        applicationId = appId
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        val appLabel = dartEnvironmentVariables["APP_LABEL"] ?: "Notify Me"
        manifestPlaceholders["appLabel"] = appLabel
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
