import 'package:equatable/equatable.dart';

/// Profile işlemlerinde oluşabilecek hata türleri
abstract class ProfileFailure extends Equatable {
  const ProfileFailure();
  
  String get message;
  
  @override
  List<Object?> get props => [];
}

/// Kullanıcı oturumu bulunamadığında oluşan hata
class ProfileAuthFailure extends ProfileFailure {
  @override
  final String message;
  
  const ProfileAuthFailure({this.message = 'Kullanıcı oturumu bulunamadı. Lütfen tekrar oturum açın.'});
  
  @override
  List<Object?> get props => [message];
}

/// Profil yüklenirken oluşan hata
class ProfileLoadFailure extends ProfileFailure {
  @override
  final String message;
  
  const ProfileLoadFailure({this.message = 'Profil yüklenirken hata oluştu'});
  
  @override
  List<Object?> get props => [message];
}

/// Profil güncellenirken oluşan hata
class ProfileUpdateFailure extends ProfileFailure {
  @override
  final String message;
  
  const ProfileUpdateFailure({this.message = 'Profil güncellenirken hata oluştu'});
  
  @override
  List<Object?> get props => [message];
}

/// Ayarlar güncellenirken oluşan hata
class ProfileSettingsUpdateFailure extends ProfileFailure {
  @override
  final String message;
  
  const ProfileSettingsUpdateFailure({this.message = 'Ayarlar güncellenirken hata oluştu'});
  
  @override
  List<Object?> get props => [message];
}

/// İzin hatası
class ProfilePermissionFailure extends ProfileFailure {
  @override
  final String message;
  
  const ProfilePermissionFailure({this.message = 'Bu işlem için izniniz yok. Lütfen tekrar oturum açın.'});
  
  @override
  List<Object?> get props => [message];
}

/// Ağ bağlantısı hatası
class ProfileNetworkFailure extends ProfileFailure {
  @override
  final String message;
  
  const ProfileNetworkFailure({this.message = 'Şu anda profil bilgilerinize erişilemiyor. Lütfen daha sonra tekrar deneyin.'});
  
  @override
  List<Object?> get props => [message];
}

/// Profil bulunamadı hatası
class ProfileNotFoundFailure extends ProfileFailure {
  @override
  final String message;
  
  const ProfileNotFoundFailure({this.message = 'Profil bilgileri bulunamadı.'});
  
  @override
  List<Object?> get props => [message];
}

/// Bilinmeyen hata
class ProfileUnknownFailure extends ProfileFailure {
  @override
  final String message;
  
  const ProfileUnknownFailure({this.message = 'Bilinmeyen bir hata oluştu'});
  
  @override
  List<Object?> get props => [message];
}
