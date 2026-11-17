# ─── Flutter Wrapper ───────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# ─── Плагины ───────────────────────────────────────────
# share_plus (использует platform channels)
-keep class dev.fluttercommunity.plus.share.** { *; }

# device_calendar
-keep class com.builttoroam.devicecalendar.** { *; }

# appcompat / локали (у вас autoStoreLocales = true в манифесте)
-keep class androidx.appcompat.app.AppLocalesMetadataHolderService { *; }
-keep class androidx.core.app.** { *; }

# Kotlin (нужно для рефлексии в некоторых плагинах)
-keep class kotlin.Metadata { *; }
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# ─── Сохранить модель данных (если используете JSON/gson/serialization) ──
# Раскомментируйте и укажите ваш пакет, если сериализуете объекты:
# -keep class ru.maxgog.listcharacters.** { *; }