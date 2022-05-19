import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nikke_e_shope/constant/color.dart';
import 'package:nikke_e_shope/services/firebase_service.dart';
import 'package:nikke_e_shope/view/prodectdetails.dart';

import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(    
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseService.userRef
                .doc(_firebaseService.getUserId())
                .collection("Cart")
                .get(),

                
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                // Display the data inside a list view
                return ListView(
                  padding: const EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetails(
                              productId: document.id,
                            ),
                          ),
                        );
                      },
                      child: FutureBuilder(
                        future:
                            _firebaseService.productsRef.doc(document.id).get(),
                        builder: (context, productSnap) {
                          if (productSnap.hasError) {
                            return Container(
                              child: Center(
                                child: Text("${productSnap.error}"),
                              ),
                            );
                          }
                          if (productSnap.connectionState ==
                              ConnectionState.done) {
                            DocumentSnapshot productMap =
                                productSnap.data as DocumentSnapshot;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 24.0,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            "${(productMap['images'][0])}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${productMap['name']}",
                                              style: const TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                              ),
                                              child: Text(
                                                "\$${productMap['price']}",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: primarycolor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Text(
                                              "Size - ${document['size']}",
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    );
                  }).toList(),
                );
              }

              // Loading State
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        Positioned(
          top: 75,
          left: 10,
          child:Text("Your Cart",style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold),))
        ],
      ),
    );
    
  }
}
