import 'package:envied/envied.dart';

part 'dev_env.g.dart';

@Envied(
  obfuscate: true,
  path: 'assets/env/.env',
)
abstract class DevEnv {
    @EnviedField(varName: 'BASE_URL')
    static final String baseUrl = _DevEnv.baseUrl;
}