import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/add_edit_coupan.dart';
import 'package:vendor_app/home_screen.dart';
import 'package:vendor_app/services/firebase_services.dart';
import 'package:intl/intl.dart';

class CoupanScreen extends StatefulWidget {
  static const String id = 'coupan-screen';
  CoupanScreen({Key key}) : super(key: key);

  @override
  _CoupanScreenState createState() => _CoupanScreenState();
}

class _CoupanScreenState extends State<CoupanScreen> {
  String coupanQuantity;
  User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState

    FirebaseFirestore.instance
        .collection('coupans')
        .where('sellerId', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        coupanQuantity = snapshot.size.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _services.coupan
            .where('sellerId', isEqualTo: _services.user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('No coupan Added Yet'),
            );
          }
          return new Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text('Coupans',
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
                                  coupanQuantity.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                                builder: (context) => AddEditCoupan()),
                          );
                        })
                  ],
                ),
              ),
              FittedBox(
                child: DataTable(
                    showBottomBorder: true,
                    dataRowHeight: 60,
                    headingRowColor: MaterialStateProperty.all(Colors.teal[50]),
                    columns: <DataColumn>[
                      DataColumn(
                          label: Text(
                        'Title',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                      DataColumn(
                          label: Text(
                        'Discount (%)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                      DataColumn(
                          label: Text(
                        'Status',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                      DataColumn(
                          label: Text(
                        'Expirey Date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                      DataColumn(
                          label: Text(
                        'Info',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ))
                    ],
                    rows: _coupanList(snapshot.data, context)),
              )
            ],
          );
        },
      ),
    );
  }

  List<DataRow> _coupanList(QuerySnapshot snapshot, context) {
    List<DataRow> newList =
        snapshot.docs.map((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot != null) {
        var date = documentSnapshot.data()['expiredate'];
        var expiredate = DateFormat.yMMMd().add_jm().format(date.toDate());
        return DataRow(cells: [
          DataCell(Text(
            documentSnapshot.data()['title'],
            style: TextStyle(fontSize: 18),
          )),
          DataCell(Text(
            '${documentSnapshot.data()['discountRate'].toString()} %',
            style: TextStyle(fontSize: 18),
          )),
          DataCell(Text(
            documentSnapshot.data()['active'] ? 'Active' : 'InActive',
            style: TextStyle(fontSize: 18),
          )),
          DataCell(Text(
            expiredate.toString(),
            style: TextStyle(fontSize: 18),
            maxLines: 2,
          )),
          // DataCell(IconButton(
          //   onPressed: () {
          //     _popButton(documentSnapshot.data());
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => AddEditCoupan(
          //                 documentSnapshot: documentSnapshot,
          //               )),
          //     );
          //   },
          //   icon: Icon(
          //     Icons.info_outline_rounded,
          //     color: Colors.teal,
          //   ),
          // )),
           DataCell(_popButton(documentSnapshot,context: context))
        ]);
      }
    }).toList();
    return newList;
  }


  Widget _popButton(document, {BuildContext context}) {
    FirebaseServices _services = FirebaseServices();

    return PopupMenuButton<String>(
        onSelected: (String value) {
          if (value == 'edit') {

            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditCoupan(
                            documentSnapshot: document,
                          )),
                 );
        //   _services.publishProduct(id: data['productId']);
          }
          if (value == 'delete') {
             _services.deletecoupanToFirebase(title: document['title']);

          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
              )),
          const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Delete Coupan'),
              )),
        ]);
  }
}
