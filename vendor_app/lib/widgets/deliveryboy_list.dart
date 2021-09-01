import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';

import 'package:vendor_app/services/firebase_services.dart';
import 'package:vendor_app/services/order_services.dart';

class DeliveryBoyList extends StatefulWidget {
  final DocumentSnapshot document;
  DeliveryBoyList({this.document});

  @override
  _DeliveryBoyListState createState() => _DeliveryBoyListState();
}

class _DeliveryBoyListState extends State<DeliveryBoyList> {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();
  GeoPoint _shopLocation;
  @override
  void initState() {
    // TODO: implement initState
    _services.getshopDetails().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            _shopLocation = value.data()['location'];
          });
        }
      } else {
        print('no data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        height: MediaQuery.of(context).size.height - 300,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              backgroundColor: Colors.teal,
              actions: [
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
              leading: Container(),
              title: Text(
                'DeliveryBoys List',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _services.deliveryboy
                      .where('accVerified', isEqualTo: true)
                      // .where('isFree', isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Sorry You dont have any DeliveryBOy'));
                    }
                    if (!snapshot.hasData) {
                      return Center(child: Text('no DeliveryMan'));
                    }
                    return new ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        GeoPoint location = document.data()['location'];
                        double distanceInMeters = _shopLocation == null
                            ? 0.0
                            : Geolocator.distanceBetween(
                                    _shopLocation.latitude,
                                    _shopLocation.longitude,
                                    location.latitude,
                                    location.longitude) /
                                1000;
                        if (distanceInMeters > 10) {
                          return Container();
                        }
                        return new ListTile(
                          onTap: () {
                            EasyLoading.show(
                                status: 'Assigning DeliveryBoy...');
                            _services
                                .selectBoy(
                                    orderId: widget.document.id,
                                    deliveryman: document.id,
                                    uid:document.data()['uid'],
                                    location: document.data()['location'],
                                    name: document.data()['name'],
                                    image: document.data()['imageUrl'],
                                    phone: document.data()['mobile'],
                                    email: document.data()['email'])
                                .then((value) {
                              EasyLoading.showSuccess('Assigned Successfully');
                              Navigator.pop(context);
                            });
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Image.network(
                                    document.data()['imageUrl'],
                                    fit: BoxFit.fill,
                                  ),
                                )),
                          ),
                          title: Text(
                            document.data()['name'],
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text('${distanceInMeters.toStringAsFixed(0)} km'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.teal[50],
                                  child: Icon(
                                    Icons.map,
                                    color: Colors.teal,
                                    size: 18,
                                  ),
                                ),
                                onPressed: () {
                                  GeoPoint location =
                                      document.data()['location'];

                                  _orderServices.launchMap(location);
                                },
                              ),
                              IconButton(
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
                                      'tel:${document.data()['mobile']}');
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
