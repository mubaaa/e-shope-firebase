import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nikke_e_shope/constant/color.dart';
import 'package:nikke_e_shope/services/firebase_service.dart';

import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  const ProductDetails({
    required this.productId,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final FirebaseService _firebaseService = FirebaseService();

  String _selecetedSize = "0";
  int _selected = 0;
  void selected(String size) {
    _selecetedSize = size;
  }

  // final User? _user = FirebaseAuth.instance.currentUser;
  Future addToCart() {
    return _firebaseService.userRef
        .doc(_firebaseService.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set(
      {'size': _selecetedSize},
    );
  }
  Future addToSavet() {
    return _firebaseService.userRef
        .doc(_firebaseService.getUserId())
        .collection("save")
        .doc(widget.productId)
        .set(
      {'size': _selecetedSize},
    );
  }
  final SnackBar _snackBar =
      const SnackBar(content: Text("product added to the cart"));
  final SnackBar _snackBar1 =
      const SnackBar(content: Text("product are saved"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Object?>>(
        future: _firebaseService.productsRef.doc(widget.productId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Center(child: Text("error : ${snapshot.error}")));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> documentData =
                snapshot.data!.data() as Map<String, dynamic>;
            //lis of image
            List imageList = documentData['images'];
            List sizeList = documentData['size'];

            //set an intial size
            // _selecetedSize = sizeList[0];
            try {
              return ListView(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 500,
                        child: PageView(
                          children: [
                            for (var i = 0; i < imageList.length; i++)
                              Image.network(
                                "${imageList[i]}",
                                fit: BoxFit.fill,
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 20,
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "${documentData['name']}",
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "₹ ${documentData['price']}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primarycolor),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "${documentData['description']}",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("Select Size",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        for (var i = 0; i < sizeList.length; i++)
                          GestureDetector(
                            onTap: () {
                              selected("${sizeList[i]}");
                              setState(() {
                                _selected = i;
                              });
                            },
                            child: Container(
                              width: 43,
                              height: 43,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: _selected == i
                                      ? primarycolor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(child: Text("${sizeList[i]}")),
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Container(
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            width: 55,
                            child: IconButton(
                                onPressed: () {
                                  addToSavet();
                                  ScaffoldMessenger.of(context).showSnackBar(_snackBar1);
                                },
                                icon: const Icon(Icons.favorite_border))),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () async {
                                await addToCart();
                                print("add to cart");
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(_snackBar);
                              },
                              child: const Text(
                                "Add To Cart",
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primarycolor)),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            } on SocketException catch (_) {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('Connection lost!!!!!!!!!!!'),
                    content: const Text('Please connect to Network'),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                      )
                    ],
                  );
                },
              );
            }
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
