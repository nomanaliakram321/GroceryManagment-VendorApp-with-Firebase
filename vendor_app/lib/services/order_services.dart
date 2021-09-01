import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendor_app/services/firebase_services.dart';
import 'package:vendor_app/widgets/deliveryboy_list.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateOrderStatus(documentId, status) {
    var result = orders.doc(documentId).update({
      'orderStatus': status,
    });
    return result;
  }

  Color colorStatus(document) {
    if (document.data()['orderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document.data()['orderStatus'] == 'Accepted') {
      return Colors.green;
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Colors.grey;
    }
    return Colors.black;
  }

  Widget statusContainer(document, context) {
    FirebaseServices _services = FirebaseServices();
    if (document.data()['deliveryboy']['name'].length > 1) {
      return document.data()['deliveryboy']['image'] == null
          ? Container(
              child: Text('No DeliveryBoy'),
            )
          : Container(
              child: Card(
                color: Colors.teal[50],
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onTap: () {
                    _showDiaglogue(context, document);
                  },
                  // onTap: () {
                  //   EasyLoading.show(status: 'Assigning DeliveryBoy...');
                  //   _services
                  //       .selectBoy(
                  //           orderId: document.id,
                  //           location: document.data()['location'],
                  //           name: document.data()['name'],
                  //           image: document.data()['imageUrl'],
                  //           phone: document.data()['mobile'])
                  //       .then((value) {
                  //     EasyLoading.showSuccess('Assigned Successfully');
                  //     Navigator.pop(context);
                  //   });
                  // },
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Image.network(
                            document.data()['deliveryboy']['image'],
                            fit: BoxFit.fill,
                          ),
                        )),
                  ),
                  title: Text(
                    document.data()['deliveryboy']['name'],
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.map,
                            color: Colors.teal,
                            size: 18,
                          ),
                        ),
                        onPressed: () {
                          GeoPoint location =
                              document.data()['deliveryboy']['location'];

                          launchMap(location);
                        },
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.phone,
                            color: Colors.teal,
                            size: 18,
                          ),
                        ),
                        onPressed: () {
                          //TODO:Pending
                          launchCall(
                              'tel:${document.data()['deliveryboy']['phone']}');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
    }
    if (document.data()['orderStatus'] == 'Accepted') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlatButton(
            color: Colors.teal,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeliveryBoyList(
                      document: document,
                    );
                  });
            },
            child: Text(
              'Assign To DeliveryBoy',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FlatButton(
            color: Colors.teal,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              showAccpetOrderDialogu(
                  'Accept Order', 'Accepted', document.id, context);
            },
            child: Text(
              'Accept',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        AbsorbPointer(
          absorbing:
              document.data()['orderStatus'] == 'Rejected' ? true : false,
          child: FlatButton(
              color: document.data()['orderStatus'] == 'Rejected'
                  ? Colors.grey
                  : Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                showAccpetOrderDialogu(
                    'Reject Order', 'Rejected', document.id, context);
              },
              child: Text(
                'Reject',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }

  showAccpetOrderDialogu(title, status, documentid, context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(
                'Are you Sure? You want to ${title.toString().trim()} this Order.'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    EasyLoading.show(status: 'Updating Status...');
                    status == 'Accepted'
                        ? updateOrderStatus(documentid, status).then((value) {
                            EasyLoading.showSuccess('Updated Successfully.');
                          })
                        : updateOrderStatus(documentid, status).then((value) {
                            EasyLoading.showSuccess('Updated Successfully.');
                          });
                    Navigator.pop(context);
                  },
                  child: Text('Yes'))
            ],
          );
        });
  }

  void launchCall(number) async => await canLaunch(number)
      ? await launch(number)
      : throw 'Could not launch $number';
  void launchMap(GeoPoint location) async {
    await MapsLauncher.launchCoordinates(
        location.latitude, location.longitude, 'DeliveryBoy are here');
  }

  _showDiaglogue(context, DocumentSnapshot document) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height - 350,
              child: Column(
                children: [
                  AppBar(
                    leading: Container(),
                    backgroundColor: Colors.teal,
                    title: Text(
                      'DeliveryBoy Details',
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                  Text(document.data()['deliveryboy']['name']),
                ],
              ),
            ),
          );
        });
  }
}
