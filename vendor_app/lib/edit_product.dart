import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/services/firebase_services.dart';
import 'package:vendor_app/widgets/categories_list.dart';
import 'package:vendor_app/widgets/sub_categories_list.dart';

class EditProductScreen extends StatefulWidget {
  final String editProducut;

  const EditProductScreen({this.editProducut});
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  FirebaseServices _services = FirebaseServices();
  final _formkey = GlobalKey<FormState>();
  List<String> _collection = [
    'Featured Products',
    'Best Selling ',
    'Recently Added'
  ];
  String dropdownValue;
  var _brandController = TextEditingController();
  var _skuController = TextEditingController();
  var _productnameController = TextEditingController();
  var _productpriceController = TextEditingController();
  var _productBeforepriceController = TextEditingController();
  var _productweightController = TextEditingController();
  var _productdescriptionController = TextEditingController();
  var _selectCategoryController = TextEditingController();
  var _subselectCategoryController = TextEditingController();
  var _stockController = TextEditingController();
  var _lowstockController = TextEditingController();
  var _taxController = TextEditingController();
  double discount;
  String image;
  File _image;
  bool _categorySelected = false;
  bool _editing = true;
  String categoryImage;
  DocumentSnapshot snapshot;

  @override
  void initState() {
    // TODO: implement initState
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.product
        .doc(widget.editProducut)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          _brandController.text = documentSnapshot.data()['brand'];
          _skuController.text = documentSnapshot.data()['sku'];
          _productnameController.text = documentSnapshot.data()['productName'];
          _productweightController.text = documentSnapshot.data()['weight'];
          _stockController.text =
              documentSnapshot.data()['stockQuantity'].toString();
          _lowstockController.text =
              documentSnapshot.data()['lowStockQuantity'].toString();
          _taxController.text = documentSnapshot.data()['tax'].toString();
          _productdescriptionController.text =
              documentSnapshot.data()['description'];
          _productBeforepriceController.text =
              documentSnapshot.data()['priceBefore'].toString();
          _productpriceController.text =
              documentSnapshot.data()['price'].toString();
          var difference = int.parse(_productBeforepriceController.text) -
              (double.parse(_productpriceController.text));
          discount = (difference /
              int.parse(_productBeforepriceController.text) *
              100);
          image = documentSnapshot.data()['productImage'];
          _selectCategoryController.text =
              documentSnapshot.data()['category']['mainCategory'];
          _subselectCategoryController.text =
              documentSnapshot.data()['category']['subCategory'];
          categoryImage = documentSnapshot.data()['categoryImage'];
          dropdownValue = documentSnapshot.data()['collection'];
          snapshot = documentSnapshot;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      bottomSheet: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                bottomRight: Radius.circular(35))),
        height: 50,
        child: Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                    )),
                alignment: Alignment.center,
                child: Text('Cancel',
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ),
            )),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (_formkey.currentState.validate()) {
                    EasyLoading.show(status: 'Saving...');
                    if (_image != null) {
                      // / need to update image
                      _provider
                          .uploadProductImage(
                              _image.path, _productnameController.text)
                          .then((url) {
                        if (url != null) {
                          EasyLoading.dismiss();
                          _provider.updateDataToFirestore(
                            context: context,
                            productName: _productnameController.text,
                            brand: _brandController.text,
                            sku: _skuController.text,
                            collection: dropdownValue,
                            description: _productdescriptionController.text,
                            lowStockQuantity:
                                int.parse(_lowstockController.text),
                            price: double.parse(_productpriceController.text),
                            priceBefore:
                                int.parse(_productBeforepriceController.text),
                            tax: double.parse(_taxController.text),
                            weight: _productweightController.text,
                            stockQuantity: int.parse(_stockController.text),
                            productId: widget.editProducut,
                            image: image,
                            category: _selectCategoryController.text,
                            subCategory: _subselectCategoryController.text,
                            categoryImage: categoryImage,
                          );
                        }
                      });
                    } else {
                      //no need to update image
                      _provider.updateDataToFirestore(
                        context: context,
                        productName: _productnameController.text,
                        brand: _brandController.text,
                        sku: _skuController.text,
                        collection: dropdownValue,
                        description: _productdescriptionController.text,
                        lowStockQuantity: int.parse(_lowstockController.text),
                        price: double.parse(_productpriceController.text),
                        priceBefore:
                            int.parse(_productBeforepriceController.text),
                        tax: double.parse(_taxController.text),
                        weight: _productweightController.text,
                        stockQuantity: int.parse(_stockController.text),
                        productId: widget.editProducut,
                        image: image,
                        category: _selectCategoryController.text,
                        subCategory: _subselectCategoryController.text,
                        categoryImage: categoryImage,
                      );
                      EasyLoading.dismiss();
                    }
                    _provider.resetData();
                  }
                },
                child: AbsorbPointer(
                  absorbing: _editing,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(35),
                        )),
                    alignment: Alignment.center,
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                setState(() {
                  _editing = false;
                });
              },
              child: Text(
                'Edit',
                style:
                    TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
              ))
        ],
        elevation: 3,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: snapshot == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formkey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _brandController,
                                  decoration: InputDecoration(
                                      prefixText: 'Brand : ',
                                      prefixStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      hintText: 'Brand',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      focusColor: Colors.teal),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('SKU : '),
                                  Container(
                                    width: 60,
                                    height: 40,
                                    child: TextFormField(
                                      controller: _skuController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'SKU',
                                          contentPadding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 8),
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400]),
                                          focusColor: Colors.teal),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              controller: _productnameController,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(

                                  //prefixIcon: Icon(Icons.,color: Colors.teal,),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  hintText: 'Product Name',
                                  focusColor: Colors.teal),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              controller: _productweightController,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                              decoration: InputDecoration(

                                  //prefixIcon: Icon(Icons.,color: Colors.teal,),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  hintText: 'Weight',
                                  focusColor: Colors.teal),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100.0,
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  controller: _productpriceController,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                      prefixText: 'Rs.',
                                      //prefixIcon: Icon(Icons.,color: Colors.teal,),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      hintText: 'Price',
                                      focusColor: Colors.teal),
                                ),
                              ),
                              Container(
                                width: 120.0,
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  controller: _productBeforepriceController,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough),
                                  decoration: InputDecoration(
                                      prefixText: 'Rs.',
                                      //prefixIcon: Icon(Icons.,color: Colors.teal,),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      hintText: 'Price',
                                      focusColor: Colors.teal),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.teal[50],
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.teal, width: 1)),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                      '${discount.toStringAsFixed(0)}% OFF',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              )
                            ],
                          ),
                          Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              child: InkWell(
                                onTap: () {
                                  _provider.getImage().then((image) {
                                    setState(() {
                                      _image = image;
                                    });
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _image != null
                                      ? Image.file(
                                          _image,
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(
                                          image,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              )),
                          Text(
                            'About this Product',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              controller: _productdescriptionController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(color: Colors.grey),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Text(
                                  'Categories',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter Product Categories';
                                      }

                                      return null;
                                    },
                                    readOnly: true,
                                    enableInteractiveSelection: true,
                                    controller: _selectCategoryController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: Visibility(
                                        // visible: _editing ? false : true,
                                        child: IconButton(
                                          color: Colors.grey,
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CategoriesList();
                                                }).whenComplete(() {
                                              _selectCategoryController.text =
                                                  _provider.selectedCategory;

                                              setState(() {
                                                _categorySelected = true;
                                              });
                                            });
                                          },
                                        ),
                                      ),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 15, 0, 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _categorySelected,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  Text(
                                    'SubCategory',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Enter Product Sub-Categories';
                                        }

                                        return null;
                                      },
                                      readOnly: true,
                                      enableInteractiveSelection: true,
                                      controller: _subselectCategoryController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        suffixIcon: IconButton(
                                          color: Colors.grey,
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SubCategoriesList();
                                                }).whenComplete(() {
                                              _subselectCategoryController
                                                      .text =
                                                  _provider.selectedSubCategory;
                                            });
                                          },
                                        ),
                                        contentPadding:
                                            EdgeInsets.fromLTRB(15, 15, 0, 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Text(
                                  'Collection',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Container(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: DropdownButton<String>(
                                      underline: SizedBox(),
                                      hint: Text('Select Collection'),
                                      isExpanded: true,
                                      value: dropdownValue,
                                      icon: Icon(Icons
                                          .arrow_drop_down_circle_outlined),
                                      items: _collection
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                            value: value, child: Text(value));
                                      }).toList(),
                                      onChanged: (String value) {
                                        setState(() {
                                          dropdownValue = value;
                                        });
                                      },
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Stock : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _stockController,
                                          style: TextStyle(color: Colors.grey),
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Low Stock : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _lowstockController,
                                          style: TextStyle(color: Colors.grey),
                                          decoration: InputDecoration(
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Tax:',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: TextFormField(
                                              controller: _taxController,
                                              style:
                                                  TextStyle(color: Colors.grey),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  suffixText: '%',
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
