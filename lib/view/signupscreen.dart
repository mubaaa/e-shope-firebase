import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nikke_e_shope/constant/color.dart';
import 'package:nikke_e_shope/constant/widgets.dart';
import 'package:nikke_e_shope/model/user_model.dart';
import 'package:nikke_e_shope/view/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool _eye = true;
  final _firstnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _lastnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 100,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              TextForm(
                validator: (value) {
                  if (value == "") {
                    return "Field is required";
                  }
                },
                obscuretext: false,
                controller: _firstnameController,
                hint: 'First Name',
                textaType: TextInputType.text,
                type: TextInputAction.next,
              ),
              TextForm(
                validator: (value) {
                  if (value == "") {
                    return "Field is required";
                  }
                },
                obscuretext: false,
                controller: _lastnameController,
                hint: 'Last Number',
                textaType: TextInputType.text,
                type: TextInputAction.next,
              ),
              TextForm(
                validator: (value) {
                  if (value == "") {
                    return "Field is required";
                  }
                },
                obscuretext: false,
                controller: _emailController,
                hint: 'Email',
                textaType: TextInputType.emailAddress,
                type: TextInputAction.next,
              ),
              TextForm(
                obscuretext: _eye,
                controller: _passwordController,
                hint: 'Password',
                textaType: TextInputType.visiblePassword,
                type: TextInputAction.done,
                validator: (value) {
                  if (value == "") {
                    return "Field is required";
                  }
                },
                suffixicon: IconButton(
                    onPressed: () {
                      setState(() {
                        _eye = !_eye;
                      });
                    },
                    icon: Icon(_eye ? Icons.visibility_off : Icons.visibility)),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  height: 50,
                  child: TxtButton(
                      onPressed: () async {
                        register();
                      },
                      text: "Register")),
              const SizedBox(
                height: 20,
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    const TextSpan(
                        text: "I have already an Account!",
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context, (route) => false);
                            
                          },
                        text: "  Login",
                        style: TextStyle(color: primarycolor, fontSize: 15))
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  void register() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        await auth
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text)
            .then((value) => postDeatlsToFirestore());
        print("signup success");
      }
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
        msg: error.message!,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.black,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  postDeatlsToFirestore() async {
    //calling our firestore
    //calling our user model
    //sending these  values

    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    final UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.firstName = _firstnameController.text;
    userModel.secondName = _lastnameController.text;
    userModel.uid = user.uid;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap())
        .catchError((err) => {print(err)});
    Fluttertoast.showToast(msg: "Account created sccessfully");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
