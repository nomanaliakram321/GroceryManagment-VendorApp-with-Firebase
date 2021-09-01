import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/services/firebase_services.dart';
import 'package:vendor_app/widgets/publish_product.dart';
import 'package:vendor_app/widgets/unpublish_product.dart';

import 'add_new_productscreen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String productquantity;
  List _catList = [];
  FirebaseServices _services = FirebaseServices();
  User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        productquantity = snapshot.size.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text('Products',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          maxRadius: 13,
                          child: FittedBox(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                productquantity.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      label: Text(
                        'Add New',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.teal,
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddNewProduct()),
                        );
                      })
                ],
              ),
              TabBar(
                  indicatorColor: Colors.teal,
                  indicatorWeight: 2,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      text: 'Published',
                    ),
                    Tab(
                      text: 'Un-Published',
                    ),
                  ]),
              Expanded(
                  child: TabBarView(
                children: [
                  PublishProduct(),
                  UnPublishProduct(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
