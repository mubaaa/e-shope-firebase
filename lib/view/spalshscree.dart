import 'package:nikke_e_shope/view/homescreen.dart';
import 'package:nikke_e_shope/view/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreenhome extends StatefulWidget {
  const SplashScreenhome({ Key? key }) : super(key: key);

  @override
  State<SplashScreenhome> createState() => _SplashScreenhomeState();
}

class _SplashScreenhomeState extends State<SplashScreenhome> {
  @override
  void initState() {
    gotoSplash();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
       body:  Center(child:   Text('Loading....',style: TextStyle(fontSize: 16),))
    );
  }
  Future gotoSplash()async{
  await Future.delayed(const Duration(seconds: 3));
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=> const AuthenticationWrapper()));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
