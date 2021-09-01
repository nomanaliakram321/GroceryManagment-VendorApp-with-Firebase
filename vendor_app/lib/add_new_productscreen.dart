import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/widgets/categories_list.dart';
import 'package:vendor_app/widgets/sub_categories_list.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'adddnewproduct - screen';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formkey = GlobalKey<FormState>();
  var _selectCategoryController = TextEditingController();
  var _subselectCategoryController = TextEditingController();
  var _priceBeforeController = TextEditingController();
  var _brandController = TextEditingController();
  var _lowerStockController = TextEditingController();
  var _stockQuantityController = TextEditingController();
  File _image;
  bool _track = false;
  bool _categorySelected = false;
  String dropdownValue;
  String productName;
  String sku;
  String weight;
  int stockQuantity;
  String productDescription;
  double productPrice;
  double productTax;
  double productPriceBefore;
  List<String> _collection = [
    'Featured Products',
    'Best Selling ',
    'Recently Added'
  ];
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.teal),
          ),
          body: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('Products',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      FlatButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          label: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.teal,
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_formkey.currentState.validate()) {
                              if (_selectCategoryController.text.isNotEmpty) {
                                if (_subselectCategoryController
                                    .text.isNotEmpty) {
                                  if (_image != null) {
                                    EasyLoading.show(status: 'Saving....');
                                    _provider
                                        .uploadProductImage(
                                            _image.path, productName)
                                        .then((url) {
                                      if (url != null) {
                                        EasyLoading.dismiss();
                                        _provider.saveDataToFirestore(
                                          context: context,
                                          productName: productName,
                                          brand: _brandController.text,
                                          collection: dropdownValue,
                                          description: productDescription,
                                          lowStockQuantity: int.parse(
                                              _lowerStockController.text),
                                          price: productPrice,
                                          priceBefore: int.parse(
                                              _priceBeforeController.text),
                                          sku: sku,
                                          stockQuantity: int.parse(
                                              _stockQuantityController.text),
                                          tax: productTax,
                                          weight: weight,
                                        );
                                        setState(() {
                                          _formkey.currentState.reset();
                                          _selectCategoryController.clear();
                                          _subselectCategoryController.clear();
                                          _priceBeforeController.clear();
                                          _brandController.clear();
                                          _lowerStockController.clear();
                                          _stockQuantityController.clear();
                                          _image = null;
                                          dropdownValue = null;
                                          _track = false;
                                          _categorySelected = false;
                                        });
                                      } else {
                                        _provider.alertDialogue(
                                            context: context,
                                            title: 'Product Image',
                                            content:
                                                'Upload Product Image Failed');
                                      }
                                    });
                                  } else {
                                    _provider.alertDialogue(
                                        context: context,
                                        title: 'Product Image',
                                        content: 'Add Product Image');
                                  }
                                } else {
                                  _provider.alertDialogue(
                                      title: 'Sub Category',
                                      content: 'Sub Category Not Selected',
                                      context: context);
                                }
                              } else {
                                _provider.alertDialogue(
                                    title: 'Main Category',
                                    content: 'Main Category Not Selected',
                                    context: context);
                              }
                            }
                          })
                    ],
                  ),
                  TabBar(
                      indicatorColor: Colors.teal,
                      indicatorWeight: 2,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: 'Gerneral',
                        ),
                        Tab(
                          text: 'Inventory',
                        ),
                      ]),
                  Expanded(
                      child: Card(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: InkWell(
                                      onTap: () {
                                        _provider.getImage().then((image) {
                                          setState(() {
                                            _image = image;
                                          });
                                        });
                                      },
                                      child: SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 3,
                                          child: _image == null
                                              ? Center(
                                                  child: Text('Select Image'))
                                              : Image.file(_image),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Enter Product Name';
                                            }
                                            setState(() {
                                              productName = value;
                                            });
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              //prefixIcon: Icon(Icons.,color: Colors.teal,),
                                              labelText: 'Name',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              hintText: 'Product Name',
                                              labelStyle:
                                                  TextStyle(color: Colors.teal),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Colors.teal)),
                                              focusColor: Colors.teal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter Product Description';
                                      }
                                      setState(() {
                                        productDescription = value;
                                      });
                                      return null;
                                    },
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        labelText: 'About Product',
                                        contentPadding:
                                            EdgeInsets.fromLTRB(15, 30, 0, 0),
                                        hintText: 'About Product',
                                        labelStyle:
                                            TextStyle(color: Colors.teal),
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.teal)),
                                        focusColor: Colors.teal),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Enter Product Price';
                                            }
                                            setState(() {
                                              productPrice =
                                                  double.parse(value);
                                            });
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: 'Price',
                                              hintText: 'Product Price',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              labelStyle:
                                                  TextStyle(color: Colors.teal),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Colors.teal)),
                                              focusColor: Colors.teal),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _priceBeforeController,
                                          validator: (value) {
                                            if (productPrice >
                                                double.parse(value)) {
                                              return 'Before Price Must be high';
                                            }

                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: 'Before Price',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              hintText: 'Before Price',
                                              labelStyle:
                                                  TextStyle(color: Colors.teal),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Colors.teal)),
                                              focusColor: Colors.teal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                              color: Colors.black, width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          underline: SizedBox(),
                                          hint: Text('Select Collection'),
                                          value: dropdownValue,
                                          icon: Icon(Icons
                                              .arrow_drop_down_circle_outlined),
                                          items: _collection
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value));
                                          }).toList(),
                                          onChanged: (String value) {
                                            setState(() {
                                              dropdownValue = value;
                                            });
                                          },
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _brandController,
                                          decoration: InputDecoration(
                                              labelText: 'Brand',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              hintText: 'Brand',
                                              labelStyle:
                                                  TextStyle(color: Colors.teal),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Colors.teal)),
                                              focusColor: Colors.teal),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Enter Product SKU';
                                            }
                                            setState(() {
                                              sku = value;
                                            });
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'SKU',
                                              hintText: 'SKU',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              labelStyle:
                                                  TextStyle(color: Colors.teal),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Colors.teal)),
                                              focusColor: Colors.teal),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormField(
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
                                        suffixIcon: IconButton(
                                          color: Colors.teal,
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
                                        labelText: 'Categories',
                                        hintText: 'Not Selected Yet',
                                        contentPadding:
                                            EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        labelStyle:
                                            TextStyle(color: Colors.teal),
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.teal)),
                                        focusColor: Colors.teal),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Visibility(
                                    visible: _categorySelected,
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
                                          suffixIcon: IconButton(
                                            color: Colors.teal,
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
                                                    _provider
                                                        .selectedSubCategory;
                                              });
                                            },
                                          ),
                                          labelText: 'Sub-Categories',
                                          hintText:
                                              'Not Sub-Categories Selected Yet',
                                          contentPadding:
                                              EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          labelStyle:
                                              TextStyle(color: Colors.teal),
                                          hintStyle: TextStyle(
                                              color: Colors.grey[400]),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  color: Colors.teal)),
                                          focusColor: Colors.teal),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Enter Product Weight';
                                            }
                                            setState(() {
                                              weight = value;
                                            });
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              //prefixIcon: Icon(Icons.,color: Colors.teal,),
                                              labelText: 'Weight',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              hintText: 'kg-gram-pound',
                                              labelStyle:
                                                  TextStyle(color: Colors.teal),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Colors.teal)),
                                              focusColor: Colors.teal),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Enter Product Tax';
                                            }
                                            setState(() {
                                              productTax = double.parse(value);
                                            });
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              labelText: 'Tax',
                                              hintText: 'Tax %',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              labelStyle:
                                                  TextStyle(color: Colors.teal),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Colors.teal)),
                                              focusColor: Colors.teal),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SingleChildScrollView(
                            child: Column(
                          children: [
                            SwitchListTile(
                                title: Text('Track Inventory'),
                                activeColor: Colors.teal,
                                subtitle: Text('Switch On to Track the Stock'),
                                value: _track,
                                onChanged: (value) {
                                  setState(() {
                                    _track = !_track;
                                  });
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: _track,
                              child: SizedBox(
                                height: 300.0,
                                width: double.infinity,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _stockQuantityController,
                                          decoration: InputDecoration(

                                              //prefixIcon: Icon(Icons.,color: Colors.teal,),
                                              labelText: 'Quantity',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              hintText: 'Inventory Quantity',
                                              labelStyle:
                                                  TextStyle(color: Colors.teal),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Colors.teal)),
                                              focusColor: Colors.teal),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: _lowerStockController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              //prefixIcon: Icon(Icons.,color: Colors.teal,),
                                              labelText: 'Low Quantity',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      15, 0, 0, 0),
                                              hintText:
                                                  'Inventory low Quantity Stock',
                                              labelStyle:
                                                  TextStyle(color: Colors.teal),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Colors.teal)),
                                              focusColor: Colors.teal),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
