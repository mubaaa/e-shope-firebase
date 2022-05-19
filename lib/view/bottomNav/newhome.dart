import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nikke_e_shope/services/firebase_service.dart';
import 'package:nikke_e_shope/view/cart_page.dart';
import 'package:nikke_e_shope/view/prodectdetails.dart';
import 'package:flutter/material.dart';

class NewHomeTab extends StatefulWidget {
  const NewHomeTab({Key? key}) : super(key: key);

  @override
  State<NewHomeTab> createState() => _NewHomeTabState();
}

class _NewHomeTabState extends State<NewHomeTab> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("products");

  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _productsRef.get(),
      builder: (context, snapshot) {
       
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(color: Colors.grey),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        if (snapshot.data == false) {
          return Scaffold(
            body: Container(
              height: 80.0,
              decoration: const BoxDecoration(color: Colors.grey),
              child: const Center(
                child: Text(
                  'Error',
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ),
          );
        }
        // collection data ready to display
        try {
          if (snapshot.connectionState == ConnectionState.done) {
            // display the data innside a list view
              print(_productsRef.id.length);
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Nik.eeee",
                  style: TextStyle(color: Colors.black, letterSpacing: 1),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CartPage()));
                      },
                      icon: const Icon(
                        Icons.shopping_bag,
                        color: Colors.black,
                      ))
                ],
                centerTitle: true,
                backgroundColor: Colors.white,
              ),
              body: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(10),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 10,
                  childAspectRatio: .63,
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
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white,
                              child: Image.network(
                                "${(document.data() as Map<String, dynamic>)['images'][0]}",
                                fit: BoxFit.fill,
                                height: 210,
                                width: double.infinity,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Text(
                                "${(document.data() as Map<String, dynamic>)['name']}",
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList()),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        } on SocketException catch (e) {
          //  print(e.message);
          return Text(e.toString());
        }
      },
    );
  }
}

// const SizedBox(height: 15),
            // const Text(
            //   "Ecommerce",
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            // const SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(15),
            //         color: const Color.fromARGB(244, 215, 216, 214)),
            //     child: TextField(
            //       controller: _searchController,
            //       decoration: const InputDecoration(
            //           hintText: "Search you're looking for",
            //           hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
            //           prefixIcon: Icon(
            //             Icons.search,
            //             color: Colors.black,
            //           ),
            //           border: InputBorder.none),
            //     ),
            //   ),
            // ),