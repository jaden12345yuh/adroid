-keep class androidx.test.** { *; }
-keep class org.junit.** { *; }
# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in C:\tools\adt-bundle-windows-x86_64-20131030\sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}
-keep class javax.** { *; }
-keep class com.siemens.mp.** { *; }
-keep class com.samsung.util.** { *; }
-keep class com.sonyericsson.accelerometer.** { *; }
-keep class com.sprintpcs.media.** { *; }
-keep class com.mascotcapsule.micro3d.v3.** { *; }
-keep class com.motorola.** { *; }
-keep class com.nokia.mid.** { *; }
-keep class com.sun.midp.midlet.** { *; }
-keep class com.vodafone.** { *; }
-keep class mmpp.media.** { *; }
-keep class org.microemu.** { *; }
-keep class ru.playsoftware.j2meloader.util.SparseIntArrayAdapter { *; }
# Keep the BuildConfig
-keep class ru.playsoftware.j2meloader.BuildConfig { *; }

-keep class androidx.appcompat.widget.SearchView { *; }
-keep class com.arthenica.mobileffmpeg.** { *; }
-keep class org.acra.attachment.DefaultAttachmentProvider { *; }
-keep class ru.playsoftware.j2meloader.crashes.models.* { *; }

plugins {
    id 'com.android.application'
}

android {
    compileSdkVersion rootProject.ext.compileSdkVersion

    defaultConfig {
        applicationId "ru.playsoftware.j2meloader"
        minSdkVersion rootProject.ext.minSdkVersion
        targetSdkVersion rootProject.ext.targetSdkVersion
        versionCode 93
        versionName "1.7.4"
        setProperty("archivesBaseName", "J2ME_Loader-$versionName")
        ndk {
            abiFilters 'x86', 'armeabi-v7a'
        }
        vectorDrawables.useSupportLibrary = true
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }
    flavorDimensions "default"

    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            applicationIdSuffix '.debug'
            jniDebuggable true
            multiDexEnabled true
            multiDexKeepProguard file('multidex-config.pro')
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    lintOptions {
        disable 'MissingTranslation'
    }

    productFlavors {
        play {
            buildConfigField "boolean", "DONATIONS_GOOGLE", "true"
            versionNameSuffix "-play"
            ndk {
                abiFilters 'x86', 'armeabi-v7a', 'x86_64', 'arm64-v8a'
            }
        }
        open {
            buildConfigField "boolean", "DONATIONS_GOOGLE", "false"
            versionNameSuffix "-open"
        }
        fdroid {
            buildConfigField "boolean", "DONATIONS_GOOGLE", "false"
        }
        dev {
            buildConfigField "boolean", "DONATIONS_GOOGLE", "false"
            versionNameSuffix "-dev-" + generateVersionCode()
        }
    }

    bundle {
        language {
            enableSplit = false
        }
        density {
            enableSplit = false
        }
        abi {
            enableSplit = true
        }
    }

    externalNativeBuild {
        ndkBuild {
            path 'src/main/cpp/Android.mk'
        }
    }
    ndkVersion '22.1.7171670'
}

static def generateVersionCode() {
    def result = "git rev-list HEAD --count".execute().text.trim()
    return result.toInteger()
}

dependencies {
    def roomVersion = '2.3.0'
    def autoServiceVersion = "1.0"

    implementation project(':dexlib')

    // Android Jetpack
    implementation "androidx.room:room-runtime:$roomVersion"
    implementation "androidx.room:room-rxjava2:$roomVersion"
    annotationProcessor "androidx.room:room-compiler:$roomVersion"
    implementation 'androidx.constraintlayout:constraintlayout:2.1.0'
    implementation 'androidx.appcompat:appcompat:1.3.1'
    implementation 'com.google.android.material:material:1.4.0'
    implementation 'androidx.preference:preference:1.1.1'
    implementation 'androidx.multidex:multidex:2.0.1'

    // Networking && APIs
    implementation 'com.android.volley:volley:1.2.0'
    implementation 'com.google.code.gson:gson:2.8.7'
    implementation 'com.github.nikita36078:donations:2.8'

    // Threads, Streams and Archives
    implementation 'io.reactivex.rxjava2:rxandroid:2.1.1'
    implementation 'net.lingala.zip4j:zip4j:2.8.0'

    // Audio/Video/Graphics
    implementation 'com.github.billthefarmer:mididriver:v1.21'
    implementation 'com.github.nikita36078:pngj:2.2.2'
    implementation 'com.github.nikita36078:mobile-ffmpeg:v4.3.2-compact'

    // Android UI
    implementation 'com.github.nikita36078:filepicker:4.3.0'
    implementation 'com.github.yukuku:ambilwarna:2.0.1'

    // Testing && CrashReports
    androidTestImplementation 'androidx.test:runner:1.4.0'
    androidTestImplementation 'androidx.test.ext:junit:1.1.3'
    testImplementation 'junit:junit:4.13.2'
    implementation 'ch.acra:acra-dialog:5.8.3'

    // Other Libraries
    implementation 'org.ow2.asm:asm:9.1'
    compileOnly "com.google.auto.service:auto-service-annotations:$autoServiceVersion"
    annotationProcessor "com.google.auto.service:auto-service:$autoServiceVersion"
}
