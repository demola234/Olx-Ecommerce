import 'package:get_it/get_it.dart';
import 'package:olx/data/remote/authentication/phone_auth_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> injector() async {
  ///Authentication
  getIt.registerLazySingleton<PhoneAuthService>(() => PhoneAuthServiceImpl());
}
