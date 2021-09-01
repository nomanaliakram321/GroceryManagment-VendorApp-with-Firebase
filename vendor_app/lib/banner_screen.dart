import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/services/firebase_services.dart';
import 'package:vendor_app/widgets/banner_list.dart';

class BannerScreen extends StatefulWidget {
  BannerScreen({Key key}) : super(key: key);
  static const String id = 'banner-screen';
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  bool _visible1 = true;
  File _image;
  var _imagePath = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Scaffold(
        body: ListView(
      children: [
        BannerImageList(),
        Divider(
          thickness: 3,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Add New Banner',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Colors.grey,
                    child: _image != null
                        ? Image.file(
                            _image,
                            fit: BoxFit.fill,
                          )
                        : Center(
                            child: Text('No Image Selected yet'),
                          ),
                  ),
                ),
                TextFormField(
                  controller: _imagePath,
                  enabled: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(),
                  ),
                ),
                Visibility(
                  visible: _visible1,
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () {
                              setState(() {
                                _visible = true;
                                _visible1 = false;
                              });
                            },
                            color: Colors.teal,
                            child: Text(
                              'Add New Banner',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _visible,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  onPressed: () {
                                    getBannerImage().then((image) {
                                      setState(() {
                                        _imagePath.text = _image.path;
                                      });
                                    });
                                  },
                                  color: Colors.teal,
                                  child: Text(
                                    'Upload Banner',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _visible = false;
                                      _visible1 = true;
                                    });
                                  },
                                  color: Colors.teal,
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: _image != null ? false : true,
                                child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () {
                                      EasyLoading.show(status: 'Saving...');
                                      uploadShopBanner(
                                              _image.path, _provider.shopName)
                                          .then((url) {
                                        if (url != null) {
                                          //store image to firebase,
                                          _services.addBannerToFirebase(url);
                                          setState(() {
                                            _imagePath.clear();
                                            _image=null;
                                          });
                                          EasyLoading.dismiss();
                                          _provider.alertDialogue(
                                              context: context,
                                              title: 'Banner Upload',
                                              content:
                                                  'Banner Uploaded Successfully');
                                        } else {
                                          EasyLoading.dismiss();

                                          _provider.alertDialogue(
                                              context: context,
                                              title: 'Banner Upload',
                                              content: 'Banner Upload Failed');
                                          //
                                        }
                                      });
                                    },
                                    color: _image != null
                                        ? Colors.teal
                                        : Colors.teal[200],
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }

  Future<File> getBannerImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
    return _image;
  }

  Future<String> uploadShopBanner(filePath, shopName) async {
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage.ref('vendorBanner/$shopName/$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadUrl = await _storage
        .ref('vendorBanner/$shopName/$timeStamp')
        .getDownloadURL();

    return downloadUrl;
  }
}
