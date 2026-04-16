// android/app/build.gradle.kts

import groovy.json.JsonSlurper

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// ✅ Read JSON file directly — no Base64 headache
val envName = project.findProperty("env")?.toString() ?: "gym_dev"
val envFile = file("../../lib/env/$envName.json")

@Suppress("UNCHECKED_CAST")
val envVars: Map<String, String> = if (envFile.exists()) {
    JsonSlurper().parse(envFile) as Map<String, String>
} else emptyMap()

android {
    namespace = "com.example.build4allgym"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.build4allgym"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ✅ Reads APP_NAME directly from your JSON file
        manifestPlaceholders["APP_NAME"] = envVars.getOrDefault("APP_NAME", "B-PRO")
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}