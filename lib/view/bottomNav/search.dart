import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nikke_e_shope/services/firebase_service.dart';
import 'package:nikke_e_shope/view/prodectdetails.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final FirebaseService _firebaseService = FirebaseService();

  String searchItem ="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 236, 232, 232),
                      ),
                      child: TextFormField(
                        onFieldSubmitted: (Value) {
                          
                          setState(() {
                            searchItem = Value.toLowerCase();
                          });
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
      ),
      body:  
      
      Container(
        child: Stack(
          children: [
            if(searchItem.isEmpty)
            Center(child:Text("Search results......"))
            else
            FutureBuilder<QuerySnapshot>(
              future: _firebaseService.productsRef
                  .where("searchname",isGreaterThanOrEqualTo: searchItem).where("searchname", isLessThan:searchItem+'z' ).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      decoration: const BoxDecoration(color: Colors.grey),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    
                  );
                }
                if (snapshot.data == false) {
                  return  Container(
                      height: 80.0,
                      decoration: const BoxDecoration(color: Colors.grey),
                      child: const Center(
                        child: Text(
                          'Error',
                          style: TextStyle(fontSize: 10.0),
                        ),
                      ),
                    
                  );
                }
                // collection data ready to display
                try {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // display the data innside a list view
                    return GridView.count(
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
                                            )));
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
                                    Text(
                                      "${(document.data() as Map<String, dynamic>)['name']}",
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList());
                  
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
            ),
          ],
        ),
      ),
    );
  }
}
