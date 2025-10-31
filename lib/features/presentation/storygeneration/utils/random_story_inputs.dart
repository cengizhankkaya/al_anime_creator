import 'dart:math';

class RandomStoryInputs {
  final String characterDetails;
  final String settingDetails;
  final String plotDetails;
  final String emotionDetails;

  const RandomStoryInputs({
    required this.characterDetails,
    required this.settingDetails,
    required this.plotDetails,
    required this.emotionDetails,
  });
}

class RandomStoryInputsGenerator {
  static final Random _random = Random();

  static const List<String> _names = [
    'Mira', 'Kerem', 'Ayla', 'Deniz', 'Eren', 'Luna', 'Arda', 'Selin',
    'Zeynep', 'Bora', 'Elif', 'Can', 'Nehir', 'Atlas', 'Yaman', 'Seda',
    'Rüya', 'Onur', 'Kuzey', 'Duru', 'Doruk', 'Defne', 'Baran'
  ];

  static const List<String> _traits = [
    'utangaç ama cesur',
    'meraklı bir mucit',
    'esprili ve hızlı',
    'soğukkanlı bir stratejist',
    'inatçı ama iyi kalpli',
    'sanatçı ruhlu',
    'mantıklı ve analitik',
    'özverili bir lider',
    'sarkastik ama güvenilir',
    'risk almayı seven',
    'ketum ve dikkatli',
    'özgür ruhlu bir gezgin',
    'başına buyruk ama adil',
    'sabırlı bir araştırmacı',
    'pratik zekalı',
    'empatik ve kararlı',
  ];

  static const List<String> _appearances = [
    'gümüş saçlı ve yeşil gözlü',
    'kıvırcık siyah saçlı',
    'gözlük takan ve uzun boylu',
    'kısa boylu, atletik',
    'robotik kolu olan',
    'yarım yüze uzanan yara izi olan',
    'mavi pelerinli',
    'dövme kaplı kolları olan',
    'koyu tenli ve ela gözlü',
    'zırh parçaları taşıyan',
    'sırt çantası ve kulaklıkla gezen',
    'mekanik göz implantı olan',
    'renkli örgülü saçlı',
    'kıyafetleri yağ ve boya lekeli',
  ];

  static const List<String> _settings = [
    'sisli bir liman şehri',
    'yüzen ada krallığı',
    'siberpunk bir metropol',
    'kadim bir orman',
    'çorak bir çöl kasabası',
    'kar küreleriyle kaplı kutup üssü',
    'yeraltı tren ağlarıyla örülü kent',
    'uçurum kenarına kurulu manastır',
    'yanardağın eteklerinde kasaba',
    'sonsuz gece yaşayan ülke',
    'antik kütüphaneler şehri',
    'okyanus altı koloni',
    'zamanın yavaş aktığı vadi',
  ];

  static const List<String> _atmospheres = [
    'gerilimli ve gizemli',
    'sıcak ve umut verici',
    'kaotik ama büyüleyici',
    'hüzünlü ve şiirsel',
    'epik ve ilham verici',
    'tekinsiz ve paranoyak',
    'nostaljik ve sıcak',
    'hızlı ve adrenalin dolu',
    'dingin ama tehditkâr',
  ];

  static const List<String> _conflicts = [
    'kaybolan bir yadigârı bulmak',
    'yasak bir teknolojiyi durdurmak',
    'imparatorluğun ihanetini ortaya çıkarmak',
    'kendi geçmişiyle yüzleşmek',
    'yaklaşan fırtınadan kasabayı kurtarmak',
    'kaybolan bir bilgeyi bulmak',
    'şifreli bir mesajı çözmek',
    'zaman döngüsünü kırmak',
    'laneti kaldıracak anahtarı bulmak',
    'rakip bir loncayı alt etmek',
    'sızan bir virüsü durdurmak',
    'gizli bir tarikatı deşifre etmek',
    'eski bir dostu kurtarmak',
    'büyük bir turnuvayı kazanmak',
  ];

  static const List<String> _emotions = [
    'melankolik ama umutlu bir ton',
    'macera dolu ve neşeli bir hava',
    'gerilimli ve karanlık bir atmosfer',
    'romantik ve içten bir duygu',
    'katartik ve arındırıcı bir duygu',
    'içsel çatışma ve kararlılık',
    'hafif mizahi bir ton',
    'epik bir kararlılık ve umut',
    'huzurlu ama gerilim alt akışı',
  ];

  static String _pick(List<String> list) => list[_random.nextInt(list.length)];

  static RandomStoryInputs generate() {
    final character = '${_pick(_names)}, ${_pick(_traits)}, ${_pick(_appearances)}';
    final setting = '${_pick(_settings)}, atmosfer: ${_pick(_atmospheres)}';
    final plot = 'Amaç: ${_pick(_conflicts)}; başlangıçta sıradan görünen bir olay, beklenmedik bir keşfe yol açar.';
    final emotion = 'Karakterin iç sesi ${_pick(_emotions)} taşır.';

    return RandomStoryInputs(
      characterDetails: character,
      settingDetails: setting,
      plotDetails: plot,
      emotionDetails: emotion,
    );
  }
}


