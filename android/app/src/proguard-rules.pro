#############################
## Flutter Default Rules
#############################

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep Flutter JNI
-keepclassmembers class * {
    @io.flutter.embedding.engine.FlutterJNI <methods>;
}

#############################
## Dart Generated Code
#############################

# Keep classes with JSON or dynamic fields
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Model classes
-keep class **.model.** { *; }
-keepclassmembers class **.model.** { *; }

#############################
## Gson / JSON Serialization
#############################

-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*

#############################
## Retrofit / OkHttp / Dio (if used)
#############################

-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**

-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

#############################
## Firebase
#############################

-dontwarn com.google.firebase.messaging.**
-dontwarn com.google.firebase.iid.**
-dontwarn com.google.firebase.installations.**
-dontwarn com.google.android.gms.internal.**

#############################
## Glide (if using images)
#############################

-keep class com.bumptech.glide.** { *; }
-dontwarn com.bumptech.glide.**

#############################
## WebSockets
#############################

-keep class org.java_websocket.** { *; }
-dontwarn org.java_websocket.**

#############################
## Kotlin Coroutines
#############################

-dontwarn kotlinx.coroutines.**
-keep class kotlinx.coroutines.** { *; }

#############################
## General Android Rules
#############################

-dontwarn javax.inject.**
-dontwarn dagger.**

#############################
## Keep annotations
#############################

-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes Signature

#############################
## Prevent removing constructors
#############################

-keepclassmembers class * {
    public <init>(...);
}

#############################
## Keep enums (important)
#############################

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
