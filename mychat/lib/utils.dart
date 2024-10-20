import 'package:get_it/get_it.dart';
import 'package:mychat/services/alert_service.dart';
import 'package:mychat/services/auth_service.dart';
import 'package:mychat/services/media_service.dart';
import 'package:mychat/services/navigation_service.dart';
import 'package:mychat/services/storage_service.dart';

Future<void> registerServices() async{
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );
  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );
  getIt.registerSingleton<AlertService>(
    AlertService(),
  );
  getIt.registerSingleton<MediaService>(
    MediaService(),
  );
  getIt.registerSingleton<StorageService>(
    StorageService(),
  );
}