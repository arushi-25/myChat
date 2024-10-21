import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mychat/consts.dart';
import 'package:mychat/models/user_profile.dart';
import 'package:mychat/services/Database_service.dart';
import 'package:mychat/services/alert_service.dart';
import 'package:mychat/services/auth_service.dart';
import 'package:mychat/services/media_service.dart';
import 'package:mychat/services/navigation_service.dart';
import 'package:mychat/services/storage_service.dart';
import 'package:mychat/widgtes/custom_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  late AuthService _authService;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late StorageService _storageService;
  late AlertService _alertService;
  late DatabaseService _databaseService;

  String? email,password,name;

  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseService>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
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
        child: Column(
          children: [
            _headertext(),
            if(!isLoading)_registerForm(),
            if(!isLoading)_loginAccountLink(),
            if(isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
               ),
             ),
           ],
        ),
      )
    );
  }
  Widget _headertext(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going !",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              ),
          ),
          Text(
            "Register an account using the form below",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              ),
          )
        ],
      ),
    );
  }
  Widget _registerForm(){
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical:  MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelectionField(),
            CustomForm(
              hintText: "Name",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: NAME_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  name = value;
                });
              }),
              CustomForm(
              hintText: "Email",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  email = value;
                });
              }),
              CustomForm(
              hintText: "Password",
              height: MediaQuery.sizeOf(context).height * 0.1,
              validationRegEx: PASSWORD_VALIDATION_REGEX,
              obscureText: true,
              onSaved: (value){
                setState(() {
                  password = value;
                });
              }),
              _registerButton(),
          ],
        )
      ),
    );
  }

  Widget _pfpSelectionField(){
    return GestureDetector(
      onTap: () async{
        File? file = await _mediaService.getImageFromGallery();
        if(file != null){
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: 
        selectedImage != null ? 
        FileImage(selectedImage!) : 
        NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }
  Widget _registerButton(){
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async{
          setState(() {
            isLoading = true;
          });
          try {
          if((_registerFormKey.currentState?.validate()?? false) && 
              selectedImage != null){
                _registerFormKey.currentState?.save();
                bool result = await _authService.signup(email!, password!);
                if(result){}
                  String? pfpURL = await _storageService.uploadUserPfp(
                    file: selectedImage!,
                    uid: _authService.user!.uid,
                );
                if(pfpURL != null){
                  await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                      uid: _authService.user!.uid, 
                      name: name, 
                      pfpURL: pfpURL
                    )
                  );
                  _alertService.showToast(
                    text: "User Registered Successfully",
                    icon: Icons.check,
                  );
                  _navigationService.goBack();
                  _navigationService.pushReplacementNamed("/Home");
                }else{
                  throw Exception("Unable to upload user profile picture");
                }
              } else{
                throw Exception("Unable to register user");
              }  
          } catch (e) {
            print(e);
            _alertService.showToast(
              text:"Failed to register, Please try again!",
              icon: Icons.error,
            );
          }
          setState(() {
            isLoading = false;
          });
        },
        child: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  Widget _loginAccountLink(){
    return Expanded(child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Already have an account?"),
        GestureDetector(
          onTap: (){
            _navigationService.goBack();
          },
          child: Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ));
  }
}