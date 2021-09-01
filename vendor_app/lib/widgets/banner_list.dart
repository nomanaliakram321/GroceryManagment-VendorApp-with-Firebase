import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendor_app/services/firebase_services.dart';

class BannerImageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    User user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: _services.vendorBanner
          .where('sellerId', isEqualTo: user.uid)
          .snapshots(),
      // stream: _services.vendorBanner.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          height: 200,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey,
                      child: Image.network(
                        document.data()['imageUrl'],
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                      right: 10,
                      top: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            EasyLoading.show(status: 'Deleting...');
                            _services.deleteBannerToFirebase(id: document.id);
                            EasyLoading.dismiss();
                          },
                        ),
                      ))
                ],
              );
            }).toList(),
          ),
        );
      },
    );
    ;
  }
}
