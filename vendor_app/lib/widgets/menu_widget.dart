import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/product_provider.dart';

class MenuWidget extends StatefulWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key key, this.onItemClick}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  User user = FirebaseAuth.instance.currentUser;
  var vendorData;
  @override
  void initState() {
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot> getVendorData() async {
    var result = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(user.uid)
        .get();
    setState(() {
      vendorData = result;
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider
        .getShopName(vendorData != null ? vendorData.data()['shopName'] : '');
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: vendorData != null
                  ? NetworkImage(
                      vendorData.data()['imageUrl'],
                    )
                  : null,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              vendorData != null ? vendorData.data()['shopName'] : 'Shop Name',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            sliderItem('DashBoard', Icons.dashboard),
            sliderItem('Products', Icons.grain),
            sliderItem('Banners', Icons.image),
            sliderItem('Coupans', Icons.card_giftcard),
            sliderItem('Orders', Icons.shopping_bag_outlined),
            sliderItem('Reports', Icons.list_alt),
            sliderItem('Setting', Icons.settings),
            sliderItem('LogOut', Icons.logout)
          ],
        ),
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) {
    return ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.teal,
          ),
        ),
        leading: Icon(
          icons,
          color: Colors.teal,
        ),
        onTap: () {
          widget.onItemClick(title);
        });
  }
}
