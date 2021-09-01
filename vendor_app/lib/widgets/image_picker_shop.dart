import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/auth_provider.dart';

class ImagePickerOfShop extends StatefulWidget {
  @override
  _ImagePickerOfShopState createState() => _ImagePickerOfShopState();
}

class _ImagePickerOfShopState extends State<ImagePickerOfShop> {
  File _image;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _authData.getImage().then((image) {
            setState(() {
              _image = image;
            });
            if (image != null) {
              _authData.isPicAvailable = true;
            }
          });
        },
        child: SizedBox(
          height: 150.0,
          width: 150.0,
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.teal, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: _image == null
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        Text('Shop Image'),
                      ],
                    ))
                  : Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
