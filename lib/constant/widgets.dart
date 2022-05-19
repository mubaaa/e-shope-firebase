import 'package:nikke_e_shope/constant/color.dart';
import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final TextInputType? textaType;
  final TextInputAction? type;
  final Widget? suffixicon;
  final validator;
  final bool obscuretext;

  const TextForm(
      {Key? key,
       this.controller,
      required this.hint,
       this.textaType,
       this.type,
       this.suffixicon,
       this.validator,
      required this.obscuretext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          
          validator: validator,
          style: const TextStyle(fontSize: 18),
          controller: controller,
          autofocus: false,
          obscureText: obscuretext,
          textInputAction: type,
          keyboardType: textaType,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              suffixIcon: suffixicon,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              hintText: hint,
              fillColor: Color.fromARGB(255, 231, 231, 231),
              filled: true,
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 128, 124, 124)),
              border: InputBorder.none),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class TxtButton extends StatelessWidget {
  final String text;
  void Function() onPressed;
  TxtButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primarycolor),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ));
  }
}
