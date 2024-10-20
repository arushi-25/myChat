import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mychat/services/alert_service.dart';
import 'package:mychat/services/auth_service.dart';
import 'package:mychat/services/navigation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final  _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;

   @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Messages",
        ),
        actions: [
          IconButton( 
            onPressed: () async{
              bool result = await _authService.logout();
              if (result){
                _alertService.showToast(
                  text: "Successfully logged out",
                  icon: Icons.check,
                  );
                _navigationService.pushReplacementNamed("/login");
              }
           },
            color: Colors.red, 
             icon: const Icon(
              Icons.logout,
          ))
        ],
      ),
    );
  }
}