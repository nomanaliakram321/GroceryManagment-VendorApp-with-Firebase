import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/services/firebase_services.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var _provider=Provider.of<ProductProvider>(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Container(
        height: 400,
        child: Column(
          children: [
            Container(

              decoration: BoxDecoration(
                  color: Colors.teal,

                  borderRadius: BorderRadius.vertical( top: Radius.circular(15) )),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Categories',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _services.category.snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went Wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return Expanded(
                    child: ListView(

                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(document.data()['image']),
                          ),
                          title: Text(document.data()['categoryName']),
                          onTap: ()
                          {
                            _provider.selectCategory(document.data()['categoryName'],document.data()['image']);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
