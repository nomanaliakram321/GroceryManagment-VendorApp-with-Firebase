import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/services/firebase_services.dart';

class SubCategoriesList extends StatefulWidget {
  const SubCategoriesList({Key key}) : super(key: key);

  @override
  _SubCategoriesListState createState() => _SubCategoriesListState();
}

class _SubCategoriesListState extends State<SubCategoriesList> {
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
                      'Select Sub-Categories',
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
            FutureBuilder<DocumentSnapshot>(

                future: _services.category.doc(_provider.selectedCategory).get(),
                builder:
                    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went Wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                   Map <String,dynamic>data=snapshot.data.data();
                    return data!=null? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Main Category',style: TextStyle(fontSize: 18),),
                                Text(_provider.selectedCategory,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                              ],

                            ),
                            SizedBox(height: 10,),
                            Divider(thickness: 2,indent: 80,endIndent: 80,),
                            Expanded(
                              child: ListView.builder(
                                // itemCount: data['subCat']==null?0:data['subCat'].length,

                                itemBuilder: (BuildContext context,int index){



                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text('${index+1}'),


                                    ),
                                    title: Text(data['subCat'][index]['name']),

                                    onTap: ()
                                    {
                                      _provider.selectSubCategory(data['subCat'][index]['name']);
                                      Navigator.pop(context);

                                    },

                                  );




                                },
                                itemCount: data['subCat']==null?0:data['subCat'].length,

                              ),
                            )
                          ],
                        ),
                      ),
                    ):Text('No Category Selected');
                  }
                  return Center(child: CircularProgressIndicator(),);

                }),
          ],
        ),
      ),
    );
  }
}
