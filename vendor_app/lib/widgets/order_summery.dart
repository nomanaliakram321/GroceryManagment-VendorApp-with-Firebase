import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/services/firebase_services.dart';
import 'package:vendor_app/services/order_services.dart';
import 'package:intl/intl.dart';

class OrderSummary extends StatefulWidget {
  final DocumentSnapshot document;
  OrderSummary({Key key, this.document});

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  OrderServices _orderServices = OrderServices();
  FirebaseServices _services = FirebaseServices();
  DocumentSnapshot _customerDetals;
  @override
  void initState() {
    // TODO: implement initState
    _services
        .getCustomerDetails(widget.document.data()['userId'])
        .then((value) {
      if (value != null) {
        setState(() {
          _customerDetals = value;
        });
      } else {
        print('no data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.teal[50],
              child: Icon(
                CupertinoIcons.square_list,
                color: _orderServices.colorStatus(widget.document),
              ),
            ),
            title: Text(
              widget.document.data()['orderStatus'].toString(),
              style: TextStyle(
                  color: _orderServices.colorStatus(widget.document),
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                'On ${DateFormat.yMMMd().format(DateTime.parse(widget.document.data()['timestamp']))}'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Payment Method:  ${widget.document.data()['code'] == true ? 'Cash On Delivery' : 'By Card'}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  ' RS. ${widget.document.data()['total'].toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _customerDetals != null
              ? ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Customer Details: ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          ' ${_customerDetals.data()['firstName']} ${_customerDetals.data()['lastName']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.teal,
                          )),
                    ],
                  ),
                  trailing: IconButton(
                    icon: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.teal[50],
                      child: Icon(
                        Icons.phone,
                        color: Colors.teal,
                        size: 18,
                      ),
                    ),
                    onPressed: () {
                      //TODO:Pending
                      _orderServices.launchCall(
                          'tel:${_customerDetals.data()['number']}');
                    },
                  ),
                  subtitle: Text(
                    'Address: ${_customerDetals.data()['address']}',
                    style: TextStyle(fontSize: 14),
                  ),
                )
              : Container(),
          ExpansionTile(
            title: Text(
              'Click Here to View Order Details',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundColor: Colors.teal,
                      backgroundColor: Colors.teal[50],
                      backgroundImage: NetworkImage(widget.document
                          .data()['products'][index]['productImage']),
                      radius: 20,
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.network(
                          widget.document.data()['products'][index]
                              ['productImage'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    title: Text(
                      widget.document.data()['products'][index]['productName'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    trailing: Text(
                        widget.document
                            .data()['products'][index]['price']
                            .toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${widget.document.data()['products'][index]['stockQuantity']} X ${widget.document.data()['products'][index]['price'].toStringAsFixed(0)} = RS ${widget.document.data()['products'][index]['total'].toStringAsFixed(0)}'),
                  );
                },
                itemCount: widget.document.data()['products'].length,
              ),
            ],
          ),
          _orderServices.statusContainer(widget.document, context),
        ],
      ),
    );
  }
}
