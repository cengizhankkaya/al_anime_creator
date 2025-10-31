class StoryGenerationErrorHandler {
  static String getErrorMessage(Object error) {
    String errorMessage = 'Hikaye oluşturulurken hata oluştu: ';
    
    if (error.toString().toLowerCase().contains('timeout')) {
      errorMessage += 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.';
    } else if (error.toString().toLowerCase().contains('resource exhausted') ||
        error.toString().toLowerCase().contains('error-code-429') ||
        error.toString().toLowerCase().contains('429')) {
      errorMessage += 'AI servisi şu anda çok yoğun. Lütfen birkaç dakika bekleyip tekrar deneyin.';
    } else if (error.toString().toLowerCase().contains('overload') ||
        error.toString().toLowerCase().contains('is overloaded') ||
        error.toString().toLowerCase().contains('unavailable')) {
      errorMessage += 'Sunucu şu anda çok meşgul (AI altyapısı kapasiteye ulaştı). Lütfen birkaç dakika sonra tekrar deneyin.';
    } else if (error.toString().toLowerCase().contains('network')) {
      errorMessage += 'İnternet bağlantınızı kontrol edin.';
    } else if (error.toString().toLowerCase().contains('permission')) {
      errorMessage += 'Bu işlem için yetkiniz bulunmuyor.';
    } else if (error.toString().toLowerCase().contains('quota')) {
      errorMessage += 'Günlük hikaye oluşturma limitiniz dolmuş.';
    } else {
      errorMessage += error.toString();
    }
    
    return errorMessage;
  }

  static String getValidationErrorMessage() {
    return 'Lütfen en az bir hikaye detayı girin';
  }

  static String getSuccessMessage() {
    return 'Hikaye başarıyla oluşturuldu ve kaydedildi!';
  }
}
