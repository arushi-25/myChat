import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mychat/models/user_profile.dart';
import 'package:mychat/services/Database_service.dart';
import 'package:mychat/services/alert_service.dart';
import 'package:mychat/services/auth_service.dart';
import 'package:mychat/services/navigation_service.dart';
import 'package:mychat/widgtes/chat_tile.dart';

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
  late DatabaseService _databaseService;

   @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
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
      body: _buildUI(),
    );
  }
  Widget _buildUI(){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: _chatsList(),
      )
    );
  }
  Widget _chatsList(){
    return StreamBuilder(
      stream: _databaseService.getUserProfile(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Center(
            child: Text("Unable to load data."),
          );
        }
        if(snapshot.hasData && snapshot.data != null){
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index){
              UserProfile user = users[index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: ChatTile(
                  userProfile: user,
                  onTap: (){}),
              );
            }
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }
}