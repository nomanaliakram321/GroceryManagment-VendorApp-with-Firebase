import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/services/firebase_services.dart';
import 'package:vendor_app/services/order_services.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  String productquantity;
  String orderquantity;
  String activeOrderQuantity;
  List _catList = [];
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;
  @override
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        productquantity = snapshot.size.toString();
      });
    });
    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        orderquantity = snapshot.size.toString();
      });
    });
    FirebaseFirestore.instance
        .collection('orders')
        .where('seller.sellerId', isEqualTo: user.uid)
        .where('orderStatus', isEqualTo: 'Accepted')
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        activeOrderQuantity = snapshot.size.toString();
      });
    });
    return Scaffold(
      body: Column(
        children: <Widget>[
          ListTile(
            subtitle: FlatButton.icon(
              onPressed: null,
              icon: Icon(null),
              label: Text(' RS. 12,000',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0, color: Colors.teal)),
            ),
            title: Text(
              'Revenue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, color: Colors.grey),
            ),
          ),
          Expanded(
            child: GridView(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Center(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_bag),
                              label: Expanded(
                                child: Text("Active Orders",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                          subtitle: Text(
                            activeOrderQuantity.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Center(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Expanded(
                                child: Text(" Total Orders",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                          subtitle: Text(
                            orderquantity.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Center(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.grain),
                              label: Text("Producs",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          subtitle: Text(
                            productquantity.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Center(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Reports",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          subtitle: Text(
                            '1',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Center(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.notifications),
                              label: Expanded(
                                child: Text("Notifications",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              )),
                          subtitle: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
