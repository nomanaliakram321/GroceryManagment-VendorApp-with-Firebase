import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/order_provider.dart';
import 'package:vendor_app/services/order_services.dart';
import 'package:vendor_app/widgets/order_summery.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int tag = 1;
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;
  List<String> options = [
    'All Orders',
    'ordered',
    'Accepted',
    'Rejected',
    'On the way',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    var _orderprovider = Provider.of<OrderProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ChipsChoice<int>.single(
                spinnerColor: Colors.teal,
                choiceStyle: C2ChoiceStyle(
                  showCheckmark: true,
                  brightness: Brightness.dark,
                  labelStyle: const TextStyle(fontSize: 14, color: Colors.teal),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  borderColor: Colors.teal,
                  color: Colors.white,
                ),
                choiceActiveStyle: const C2ChoiceStyle(
                  color: Colors.teal,
                  elevation: 5,
                  labelStyle:
                      const TextStyle(fontSize: 14, color: Colors.white),
                  borderShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      side: BorderSide(color: Colors.teal)),
                ),
                value: tag,
                onChanged: (val) {
                  if (val == 0) {
                    setState(() {
                      _orderprovider.status = null;
                    });
                  }
                  setState(() {
                    tag = val;
                    _orderprovider.status = options[val];
                  });
                },
                choiceItems: C2Choice.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
              ),
            ),
            // OrderWidget()
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _orderServices.orders
                    .where('seller.sellerId', isEqualTo: user.uid)
                    .where('orderStatus',
                        isEqualTo: tag > 0 ? _orderprovider.status : null)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('Sorry You dont have any order'));
                  }
                  if (snapshot.data.size == 0) {
                    return Center(
                        child: Text(tag > 0
                            ? 'NO  ${options[tag]} Orders Yet'
                            : 'No order Yet'));
                  }

                  return Column(
                    children: [
                      new ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return OrderSummary(
                            document: document,
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
