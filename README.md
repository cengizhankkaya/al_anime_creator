# AL Anime Creator

AI destekli  hikaye üretimi ve yönetimi sunan, Flutter ile geliştirilen çok platformlu bir uygulama. Uygulama; Firebase kimlik doğrulama, Firestore veri saklama, `firebase_ai` ile metin üretimi, `auto_route` ile gelişmiş yönlendirme, `flutter_bloc` ile durum yönetimi ve `easy_localization` ile çok dillilik özelliklerini içerir.

## İçindekiler
- Genel Bakış
- Özellikler
- Mimarî ve Klasör Yapısı
- Kurulum
  - Gerekli Araçlar
  - Bağımlılıkların Yüklenmesi
  - Çevresel Değişkenler ve Yapılandırma
  - Firebase Kurulumu
- Çalıştırma ve Komutlar
- Yerelleştirme (i18n)
- Navigasyon (auto_route)
- Durum Yönetimi (flutter_bloc)
- Yapay Zeka Servisi (firebase_ai)
- Platform Notları (iOS/Android/Web)
- Sorun Giderme
- Katkı ve Lisans


## Özellikler
- AI ile Türkçe anime tarzında hikâye üretimi
- Hikâyeyi manuel prompt ile veya otomatik olarak devam ettirme
- Uzunluk ve yaratıcılık (karmaşıklık) kontrolü
- Firebase Auth ile oturum açma/kapama
- Firestore üzerinde hikâye kaydetme ve geçmiş görüntüleme
- Sidebar tabanlı çok sayfalı arayüz, `auto_route` ile nested route yapısı
- Karanlık/Aydınlık tema desteği
- `easy_localization` ile TR/EN çok dillilik
- Rive animasyonları ve SVG varlıkları

## Mimarî ve Klasör Yapısı
Uygulama, katmanlı mimarî ile yapılandırılmıştır:

```
lib/
  features/
    core/                 # Tema, renkler, router, servis lokatörü, network servisleri
    data/                 # Modeller ve repository implementasyonları
    domain/               # (Varsa) arayüzler ve iş kuralları
    presentation/         # Cubit/State, View ve Widgetlar
  firebase_options.dart   # FlutterFire ile üretilmiş Firebase yapılandırması
  main.dart               # Giriş noktası, MultiBlocProvider ve MaterialApp.router
assets/
  translations/           # en.json, tr.json
  RiveAssets/             # Rive animasyonları
  icons/, Backgrounds/, avaters/ vb.
```

Temel akışlar:
- `main.dart` içerisinde `ApplicationInitialize().make()` sonrası `ProductLocalization` ile sarmalanmış `MyApp` başlatılır.
- `AppRouter` ile Splash → Onboarding → EntryPoint alt rotaları kurgulanır.
- `AuthGuard` ve `SidebarCubit` gibi bileşenler Firebase Auth durumunu dinler.
- `StoryGenerationCubit` kullanıcı girdilerini doğrular, `StoryGenerationRepository` aracılığıyla `AIService` ve `FirestoreService` etkileşimini yönetir.

## Kurulum

### Gerekli Araçlar
- Flutter SDK (Dart ^3.9.2 uyumlu)
- Xcode (iOS için), Android Studio/SDK (Android için)
- Firebase projesi ve mobil konfigürasyon dosyaları

### Bağımlılıkların Yüklenmesi
```bash
flutter pub get
```

Gerekli kod üretimleri (router vb.) için:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Çevresel Değişkenler ve Yapılandırma
Projede `flutter_dotenv` ve `envied` bağımlılıkları mevcut. Gizli anahtarlarınızı repoya koymayın. Eğer `.env` kullanacaksanız, `assets/env/` veya kök dizinde ilgili dosyayı oluşturup kodda referanslayın. `envied` kullanırken değişkenleri `Envied` anotasyonlarıyla tanımlayıp `envied_generator` ile üretim yapın.

### Firebase Kurulumu
1. Firebase Console’da bir proje oluşturun.
2. iOS için `GoogleService-Info.plist` dosyasını `ios/Runner/` içine koyun.
3. Android için `google-services.json` dosyasını `android/app/` içine koyun.
4. `flutterfire configure` ile `lib/firebase_options.dart` dosyasını üretin veya mevcut dosyayı güncelleyin.
5. iOS’ta Pod kurulumlarını yenileyin:
   ```bash
   cd ios && pod install && cd ..
   ```

> Not: Web ve masaüstü platformları bu projede varsayılan olarak kapalıdır. Gerekirse `firebase_options.dart` içerisinde ilgili platformlar için konfigürasyon ekleyin.

## Çalıştırma ve Komutlar

Geliştirme sırasında:
```bash
flutter run
```

Belirli bir platformda çalıştırma:
```bash
flutter run -d ios
flutter run -d android
```

Release build alma:
```bash
flutter build apk --release
flutter build ios --release
```

Router ve Envied gibi kod üretimleri:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Yerelleştirme (i18n)
`easy_localization` ile `assets/translations/en.json` ve `assets/translations/tr.json` dosyaları yüklenir. `MaterialApp.router` içinde `locale`, `localizationsDelegates`, `supportedLocales` bağlanmıştır. Yeni dil eklemek için ilgili JSON dosyasını ekleyip `assets` listesine dizini zaten tanımlı olduğu için sadece çeviriyi eklemeniz yeterlidir.

## Navigasyon (auto_route)
Router tanımı `features/core/config/navigation/app_router.dart` içinde yapılır ve `part 'app_router.gr.dart';` ile jenerik kod üretilir. Rotaları güncelledikten sonra:
```bash
dart run build_runner build --delete-conflicting-outputs
```
`MyApp` içinde `MaterialApp.router` → `routerConfig: appRouter.config()` kullanılır. Nested route’lar `EntryPointRoute` altında tanımlıdır.

## Durum Yönetimi (flutter_bloc)
Uygulama `Cubit` tabanlıdır. Örnekler:
- `AuthCubit`: oturum durumları ve yönlendirme
- `SplashCubit`: açılış akışı
- `SidebarCubit`: kullanıcı profilini ve auth durumunu dinleme
- `StoryGenerationCubit`: doğrulama, yükleme, üretim ve sonuç durumları

`MultiBlocProvider` uygulama seviyesinde konumlandırılmıştır ve bazı widget’lar içinde ek `BlocProvider` kullanımları bulunmaktadır.

## Yapay Zeka Servisi (firebase_ai)
`AIServiceImpl`, `firebase_ai` `GenerativeModel` kullanarak prompt temelli içerik üretir. Önemli noktalar:
- İstek zaman aşımı ve kullanıcıya dost hata mesajları `StoryGenerationErrorHandler` ile yönetilir.
- Üretilen içerik `StoryGenerationRepositoryImpl` tarafından normalize edilip Firestore’a kaydedilir.
- Uzunluk ve yaratıcılık parametreleri prompt içine işlenir.




