import 'package:nikke_e_shope/constant/color.dart';
import 'package:nikke_e_shope/constant/widgets.dart';
import 'package:nikke_e_shope/view/homescreen.dart';
import 'package:nikke_e_shope/view/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignInAccount? user;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _showpassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Hi......! Welcome Back",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            TextForm(
                controller: _emailcontroller,
                hint: "Email",
                textaType: TextInputType.emailAddress,
                type: TextInputAction.next,
                validator: (value) {
                  if (value == "") {
                    return "field is required";
                  }
                },
                obscuretext: false),
            TextForm(
              controller: _passcontroller,
              hint: "Password",
              textaType: TextInputType.emailAddress,
              type: TextInputAction.next,
              validator: (value) {
                if (value == "") {
                  return "field is required";
                }
              },
              obscuretext: _showpassword,
              suffixicon: IconButton(
                  onPressed: () {
                    setState(() {
                      _showpassword = !_showpassword;
                    });
                  },
                  icon: Icon(
                      _showpassword ? Icons.visibility_off : Icons.visibility)),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 45,
              child: TxtButton(
                  onPressed: () {
                    login();
                  },
                  text: "LOGIN"),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Or login With",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: GestureDetector(
                onTap: () {
                  signinWithGoogle();
                  // final _sharedPrefence =
                  //           await SharedPreferences.getInstance();
                  //       _sharedPrefence.setBool(saveKey, true);
                  //       if (user != null) {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (ctx) =>  const Home()));
                  //       }
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 204, 201, 201))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "asset/logo.png",
                        scale: 2,
                        width: 40,
                        alignment: Alignment.center,
                      ),
                      const Text(" Google", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                      text: "Not a member? ",
                      style: TextStyle(color: Colors.black, fontSize: 15)),
                  TextSpan(
                    text: "Sign up now",
                    style: TextStyle(color: primarycolor, fontSize: 15),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          isLoading = true;
        });
        FocusScope.of(context).requestFocus(FocusNode());

        await auth
            .signInWithEmailAndPassword(
                email: _emailcontroller.text.trim(),
                password: _passcontroller.text.trim())
            .then(
          (value) {
            Fluttertoast.showToast(msg: "Login Successfully");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) =>  HomeScreen(),
              ),
            );
          },
        );
      }
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
        msg: error.message!,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.black,
      );
      // } on SocketException catch (_) {
      //   showDialog(
      //           context: context,
      //           builder: (_) {
      //             return AlertDialog(
      //               title: Text('Authentication failed!'),
      //               content: Text('Please try again'),
      //              actions: [
      //                GestureDetector(
      //                  onTap: () {
      //                 Navigator.pop(context, true);

      //               },
      //                )
      //              ],
      //             );
      //           });
    }
    setState(() {
      isLoading = false;
    });
  }

  signinWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    } else {
      user = googleUser;
      print(user!.email);
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) =>  HomeScreen()));
    }
  }
}
