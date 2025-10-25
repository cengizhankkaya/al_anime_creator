/// Profile modülü için sabitler
class ProfileConstants {
  // Renkler
  static const int primaryBackgroundColor = 0xFF0F0F0F;
  static const int secondaryBackgroundColor = 0xFF1A1A1A;
  static const int primaryAccentColor = 0xFF24FF00;
  
  // Boyutlar
  static const double defaultPadding = 20.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 40.0;
  static const double borderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  
  // Avatar boyutları
  static const double avatarSize = 60.0;
  static const double avatarIconSize = 30.0;
  
  // Font boyutları
  static const double titleFontSize = 20.0;
  static const double sectionTitleFontSize = 16.0;
  static const double nameFontSize = 18.0;
  static const double subtitleFontSize = 14.0;
  
  // Icon boyutları
  static const double defaultIconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 64.0;
  
  // Delay süreleri
  static const Duration errorRetryDelay = Duration(seconds: 1);
  
  // Firebase koleksiyon adları
  static const String usersCollection = 'users';
  
  // Varsayılan ayarlar
  static const String defaultLanguage = 'Türkçe';
  static const String defaultTheme = 'Koyu';
  static const bool defaultNotificationsEnabled = true;
  static const bool defaultSoundEnabled = true;
  
  // Desteklenen diller
  static const List<String> supportedLanguages = ['Türkçe', 'English'];
  
  // Desteklenen temalar
  static const List<String> supportedThemes = ['Koyu', 'Açık'];
  
  // Hata mesajları
  static const String authErrorMessage = 'Kullanıcı oturumu bulunamadı. Lütfen tekrar oturum açın.';
  static const String loadErrorMessage = 'Profil yüklenirken hata oluştu';
  static const String updateErrorMessage = 'Profil güncellenirken hata oluştu';
  static const String settingsUpdateErrorMessage = 'Ayarlar güncellenirken hata oluştu';
  static const String permissionErrorMessage = 'Bu işlem için izniniz yok. Lütfen tekrar oturum açın.';
  static const String networkErrorMessage = 'Şu anda profil bilgilerinize erişilemiyor. Lütfen daha sonra tekrar deneyin.';
  static const String notFoundErrorMessage = 'Profil bilgileri bulunamadı.';
  static const String unknownErrorMessage = 'Bilinmeyen bir hata oluştu';
  
  // UI metinleri
  static const String profileTitle = 'Profile';
  static const String generalSectionTitle = 'Genel';
  static const String contentSectionTitle = 'İçerik';
  static const String languageTitle = 'Diller';
  static const String themeTitle = 'Tema';
  static const String aboutTitle = 'Hakkımızda';
  static const String privacyTitle = 'Gizlilik Politikası';
  static const String termsTitle = 'Kullanım Koşulları';
  static const String logoutTitle = 'Çıkış Yap';
  static const String signInRequiredTitle = 'Oturum Açmanız Gerekiyor';
  static const String signInRequiredMessage = 'Profil ayarlarını görüntülemek için lütfen oturum açın.';
  static const String signInButtonText = 'Oturum Aç';
  static const String unknownStateMessage = 'Bilinmeyen durum';
  static const String selectLanguageTitle = 'Dil Seçin';
  static const String selectThemeTitle = 'Tema Seçin';
  static const String accountSectionTitle = 'Hesap';
}
