import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychat/firebase_options.dart';
import 'package:mychat/pages/login_page.dart';
import 'package:mychat/services/auth_service.dart';
import 'package:mychat/services/navigation_service.dart';
import 'package:mychat/utils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  await registerServices(); 
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  final GetIt _getIt = GetIt.instance;

  late NavigationService _navigationservice;
  late AuthService _authService;

  
  MyApp({super.key}){
    _navigationservice = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationservice.navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue),
        textTheme: GoogleFonts.montserratTextTheme(),
       ),
      debugShowCheckedModeBanner: false,
      initialRoute: _authService.user != null ? "/Home" :"/login",
      routes: _navigationservice.routes,
    );
  }
}