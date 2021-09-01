import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/edit_product.dart';
import 'package:vendor_app/services/firebase_services.dart';

class UnPublishProduct extends StatelessWidget {
  const UnPublishProduct({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    User user = FirebaseAuth.instance.currentUser;
    return Container(
      child: StreamBuilder(
        stream: _services.product
            .where('published', isEqualTo: false)
            .where('seller.sellerUid', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: SizedBox(
                    height: 30, width: 30, child: CircularProgressIndicator()));
          }
          if (snapshot.data != null) {
            return SingleChildScrollView(
              child: FittedBox(
                child: DataTable(
                  showBottomBorder: true,
                  dataRowHeight: 60,
                  headingRowColor: MaterialStateProperty.all(Colors.teal[50]),
                  columns: <DataColumn>[
                    DataColumn(
                        label: Text(
                      ' Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Image',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Info',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Action',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                  rows: _productDetails(snapshot.data, context),
                ),
              ),
            );
          } else {
            return Center(child: Text('No Product Added Yet'));
          }
        },
      ),
    );
  }

  List<DataRow> _productDetails(QuerySnapshot snapshot, context) {
    List<DataRow> newList =
        snapshot.docs.map((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot != null) {
        return DataRow(cells: [
          DataCell(Container(
              child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              documentSnapshot.data()['productName'],
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
            ),
            subtitle: Row(
              children: [
                Text(
                  'SKU : ',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: Colors.black),
                ),
                Text(documentSnapshot.data()['sku']),
              ],
            ),
          ))),
          DataCell(Container(
              child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: [
                Image.network(
                  documentSnapshot.data()['productImage'],
                  width: 50,
                ),
              ],
            ),
          ))),
          DataCell(IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProductScreen(
                            editProducut: documentSnapshot.data()['productId'],
                          )));
            },
          )),
          DataCell(_popButton(documentSnapshot.data()))
        ]);
      }
    }).toList();
    return newList;
  }

  Widget _popButton(data, {BuildContext context}) {
    FirebaseServices _services = FirebaseServices();

    return PopupMenuButton<String>(
        onSelected: (String value) {
          if (value == 'publish') {
            _services.publishProduct(id: data['productId']);
          }
          if (value == 'delete') {
            _services.deleteProduct(id: data['productId']);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                  value: 'publish',
                  child: ListTile(
                    leading: Icon(Icons.check),
                    title: Text('Publish'),
                  )),
              const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Delete Product'),
                  )),
            ]);
  }
}
