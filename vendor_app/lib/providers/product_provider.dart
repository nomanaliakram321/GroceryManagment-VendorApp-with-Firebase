import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String selectedCategory;
  String selectedSubCategory;
  String categoryImage;
  File image;
  String pickerError;
  String productUrl;
  String shopName;
  selectCategory(maincategory, categoryImage) {
    this.selectedCategory = maincategory;
    this.categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(category) {
    this.selectedSubCategory = category;

    notifyListeners();
  }

  getShopName(shopname) {
    this.shopName = shopname;
    notifyListeners();
  }

  resetData() {
    //remove all existing data before updating data
    this.selectedCategory = null;
    this.selectedSubCategory = null;
    this.categoryImage = null;
    this.image = null;
    this.productUrl = null;
    notifyListeners();
  }

  Future<String> uploadProductImage(filePath, productName) async {
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadUrl = await _storage
        .ref('productImage/${this.shopName}/$productName$timeStamp')
        .getDownloadURL();
    this.productUrl = downloadUrl;
    notifyListeners();
    return downloadUrl;
  }

  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected.';
      print('No image selected.');
      notifyListeners();
    }
    return this.image;
  }

  alertDialogue({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
  //save data to firebase

  Future<void> saveDataToFirestore({
    context,
    productName,
    description,
    price,
    priceBefore,
    collection,
    sku,
    brand,
    weight,
    tax,
    stockQuantity,
    lowStockQuantity,
  }) {
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;
    User user = FirebaseAuth.instance.currentUser;

    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');

    try {
      _products.doc(timeStamp.toString()).set({
        'seller': {
          'shopName': this.shopName,
          'sellerUid': user.uid,
        },
        'price': price,
        'productName': productName,
        'description': description,
        'collection': collection,
        'priceBefore': priceBefore,
        'category': {
          'mainCategory': this.selectedCategory,
          'subCategory': this.selectedSubCategory,
          'categoryImage': this.categoryImage,
        },
        'sku': sku,
        'brand': brand,
        'weight': weight,
        'tax': tax,
        'stockQuantity': stockQuantity,
        'lowStockQuantity': lowStockQuantity,
        'published': false,
        'productId': timeStamp.toString(),
        'productImage': this.productUrl,
        'sellerUid': user.uid,
      });
      this.alertDialogue(
          context: context,
          title: 'Save Data',
          content: 'Save Data Successfully');
    } catch (e) {
      this.alertDialogue(
          context: context, title: 'Save Data', content: '${e.toString()}');
    }
    return null;
  }

  Future<void> updateDataToFirestore({
    context,
    productName,
    description,
    price,
    priceBefore,
    collection,
    sku,
    brand,
    weight,
    tax,
    stockQuantity,
    lowStockQuantity,
    productId,
    image,
    category,
    subCategory,
    categoryImage,
  }) {
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');

    try {
      _products.doc(productId).update({
        'price': price,
        'productName': productName,
        'description': description,
        'collection': collection,
        'priceBefore': priceBefore,
        'category': {
          'mainCategory': category,
          'subCategory': subCategory,
          'categoryImage':
              this.categoryImage == null ? categoryImage : this.categoryImage,
        },
        'sku': sku,
        'brand': brand,
        'weight': weight,
        'tax': tax,
        'stockQuantity': stockQuantity,
        'lowStockQuantity': lowStockQuantity,
        'productImage': this.productUrl == null ? image : this.productUrl,
      });
      this.alertDialogue(
          context: context,
          title: 'Save Data',
          content: 'Save Data Successfully');
    } catch (e) {
      this.alertDialogue(
          context: context, title: 'Save Data', content: '${e.toString()}');
    }
    return null;
  }
}
