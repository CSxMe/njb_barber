# دليل تثبيت تطبيق الحلاقة للمطورين

## متطلبات النظام

- Flutter SDK 3.0.0 أو أحدث
- Dart SDK 3.0.0 أو أحدث
- Android Studio / VS Code
- للتشغيل على iOS: جهاز Mac مع Xcode
- للتشغيل على Android: Android SDK

## خطوات التثبيت

### 1. تثبيت Flutter SDK

#### على نظام Windows
1. قم بتنزيل Flutter SDK من [الموقع الرسمي](https://flutter.dev/docs/get-started/install/windows).
2. قم بفك ضغط الملف في المسار المطلوب (مثلاً: `C:\src\flutter`).
3. أضف مجلد `flutter\bin` إلى متغير البيئة PATH.
4. افتح موجه الأوامر وتحقق من التثبيت باستخدام الأمر:
   ```
   flutter doctor
   ```

#### على نظام macOS
1. قم بتنزيل Flutter SDK من [الموقع الرسمي](https://flutter.dev/docs/get-started/install/macos).
2. قم بفك ضغط الملف في المسار المطلوب (مثلاً: `~/development/flutter`).
3. أضف مجلد `flutter/bin` إلى متغير البيئة PATH في ملف `~/.zshrc` أو `~/.bash_profile`:
   ```
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. افتح Terminal وتحقق من التثبيت باستخدام الأمر:
   ```
   flutter doctor
   ```

#### على نظام Linux
1. قم بتنزيل Flutter SDK من [الموقع الرسمي](https://flutter.dev/docs/get-started/install/linux).
2. قم بفك ضغط الملف في المسار المطلوب (مثلاً: `~/development/flutter`).
3. أضف مجلد `flutter/bin` إلى متغير البيئة PATH في ملف `~/.bashrc`:
   ```
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. افتح Terminal وتحقق من التثبيت باستخدام الأمر:
   ```
   flutter doctor
   ```

### 2. تثبيت بيئة التطوير

#### Android Studio
1. قم بتنزيل وتثبيت [Android Studio](https://developer.android.com/studio).
2. قم بتثبيت إضافة Flutter من خلال:
   - افتح Android Studio
   - انتقل إلى File > Settings > Plugins
   - ابحث عن "Flutter" وقم بتثبيت الإضافة
   - أعد تشغيل Android Studio

#### VS Code
1. قم بتنزيل وتثبيت [VS Code](https://code.visualstudio.com/).
2. قم بتثبيت إضافة Flutter من خلال:
   - افتح VS Code
   - انتقل إلى Extensions (Ctrl+Shift+X)
   - ابحث عن "Flutter" وقم بتثبيت الإضافة

### 3. تنزيل المشروع

1. قم بتنزيل أو استنساخ المشروع من المستودع:
   ```
   git clone https://github.com/yourusername/barber_shop_app.git
   ```
2. انتقل إلى مجلد المشروع:
   ```
   cd barber_shop_app
   ```

### 4. تثبيت التبعيات

قم بتثبيت التبعيات المطلوبة باستخدام الأمر:
```
flutter pub get
```

### 5. تشغيل التطبيق

#### في وضع التصحيح
```
flutter run
```

#### بناء نسخة الإنتاج

##### لنظام Android
```
flutter build apk --release
```
ستجد ملف APK في المسار:
```
build/app/outputs/flutter-apk/app-release.apk
```

##### لنظام iOS (يتطلب جهاز Mac)
```
flutter build ios --release
```
ثم افتح مشروع Xcode وقم ببناء وتوزيع التطبيق.

## هيكل المشروع

```
lib/
  ├── l10n/                  # ملفات الترجمة
  │   ├── app_ar.arb         # الترجمة العربية
  │   └── app_en.arb         # الترجمة الإنجليزية
  ├── providers/             # مزودي الحالة
  │   ├── app_status_provider.dart
  │   ├── barber_auth_provider.dart
  │   └── waiting_list_provider.dart
  ├── screens/               # شاشات التطبيق
  │   ├── barber_login_screen.dart
  │   ├── barber_screen.dart
  │   └── customer_screen.dart
  ├── services/              # خدمات التطبيق
  │   ├── app_initializer.dart
  │   └── hive_service.dart
  ├── widgets/               # عناصر واجهة المستخدم
  │   ├── app_footer.dart
  │   ├── barber_action_buttons.dart
  │   ├── customer_name_input.dart
  │   ├── shop_status_toggle.dart
  │   └── waiting_list_view.dart
  └── main.dart              # نقطة الدخول للتطبيق
```

## تخصيص التطبيق

### تغيير كلمة المرور الافتراضية

افتح ملف `lib/providers/barber_auth_provider.dart` وقم بتغيير قيمة `_password` الافتراضية:

```dart
String _password = 'your_new_password'; // Default password
```

### إضافة لغات جديدة

1. أنشئ ملف ترجمة جديد في مجلد `lib/l10n/` باسم `app_[language_code].arb`.
2. انسخ محتوى ملف `app_en.arb` وترجم القيم إلى اللغة المطلوبة.
3. أضف اللغة الجديدة إلى قائمة `supportedLocales` في ملف `lib/main.dart`.

### تغيير مظهر التطبيق

لتغيير الألوان الرئيسية للتطبيق، قم بتعديل `theme` في ملف `lib/main.dart`:

```dart
theme: ThemeData(
  primarySwatch: Colors.blue, // تغيير من Colors.blueGrey إلى اللون المطلوب
  // تخصيصات أخرى...
),
```

## اختبار التطبيق

### تشغيل الاختبارات

```
flutter test
```

### إضافة اختبارات جديدة

أضف ملفات اختبار جديدة في مجلد `test/` باتباع نمط الاختبارات الموجودة.

## بناء وتوزيع التطبيق

### توزيع على Google Play

1. أنشئ حساب مطور على [Google Play Console](https://play.google.com/console/signup).
2. أنشئ تطبيقًا جديدًا وأكمل معلومات التطبيق.
3. قم ببناء نسخة الإنتاج:
   ```
   flutter build appbundle --release
   ```
4. قم برفع ملف AAB الناتج إلى Google Play Console.

### توزيع على App Store

1. أنشئ حساب مطور على [Apple Developer Program](https://developer.apple.com/programs/).
2. أنشئ معرف تطبيق جديد في [App Store Connect](https://appstoreconnect.apple.com/).
3. قم ببناء نسخة الإنتاج:
   ```
   flutter build ios --release
   ```
4. افتح مشروع Xcode وقم بتوزيع التطبيق باستخدام Xcode.

## استكشاف الأخطاء وإصلاحها

### مشاكل في تثبيت Flutter

قم بتشغيل الأمر التالي لمعرفة المشاكل وكيفية إصلاحها:
```
flutter doctor -v
```

### مشاكل في تثبيت التبعيات

حاول حذف ملف `pubspec.lock` وتشغيل الأمر:
```
flutter pub get
```

### مشاكل في بناء التطبيق

قم بتنظيف المشروع وإعادة البناء:
```
flutter clean
flutter pub get
flutter run
```

