# Please remove this if anything goes wrong to see the actually warnings
-dontwarn javax.naming.**

-keep class org.bouncycastle.** { *; }  # use broad rules for SDK dependency

# Starting with AGP 8.0, R8 "Full Mode" (non-compatibility mode) is enabled by default. This mode performs more aggressive optimizations.
-keep class ae.network.nicardmanagementsdk.** { *; }
-keepclassmembers class ae.network.nicardmanagementsdk.** { *; }
