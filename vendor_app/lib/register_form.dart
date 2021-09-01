import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/home_screen.dart';
import 'package:vendor_app/login_screen.dart';
import 'package:vendor_app/providers/auth_provider.dart';

class RegistorForm extends StatefulWidget {
  RegistorForm({Key key}) : super(key: key);

  @override
  _RegistorFormState createState() => _RegistorFormState();
}

class _RegistorFormState extends State<RegistorForm> {
  final _formkey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _cPasswordTextController = TextEditingController();
  var _locationTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  var _diaglogTextController = TextEditingController();
  String email;
  String password;
  String mobile;
  String shopName;
  bool _isloading = false;
  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('uploads/shopPictures/${_nameTextController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadUrl = await _storage
        .ref('uploads/shopPictures/${_nameTextController.text}')
        .getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    errorMessage(message) {
      return Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return Container(
      child: _isloading
          ? CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            )
          : Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Shop Name';
                        }
                        setState(() {
                          _nameTextController.text = value;
                        });
                        setState(() {
                          shopName = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add_business),
                          labelText: 'Shop Name',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal)),
                          focusColor: Colors.teal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      maxLength: 10,
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Phone Number';
                        }
                        setState(() {
                          mobile = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.tablet_android),
                          prefixText: '+92',
                          labelText: 'Phone Number',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal)),
                          focusColor: Colors.teal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Shop Email';
                        }

                        final bool isValid =
                            EmailValidator.validate(_emailTextController.text);
                        if (!isValid) {
                          return 'invalid Email';
                        }
                        setState(() {
                          email = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'Shop Email',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal)),
                          focusColor: Colors.teal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordTextController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Password';
                        }
                        if (value.length < 6) {
                          return 'Minimum 6 characters';
                        }
                        setState(() {
                          password = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_open_outlined),
                          labelText: 'Enter Password',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal)),
                          focusColor: Colors.teal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      controller: _cPasswordTextController,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Confirm Password';
                        }
                        if (_passwordTextController.text !=
                            _cPasswordTextController.text) {
                          return 'Password Does not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_open_outlined),
                          labelText: 'Confirm Password',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal)),
                          focusColor: Colors.teal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      maxLines: 4,
                      controller: _locationTextController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Address';
                        }
                        if (_authData.shopLatitude == null) {
                          return 'Press Navigator Icon';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.location_searching),
                            onPressed: () {
                              _locationTextController.text =
                                  'Locating.....\n Please wait...';
                              _authData.getCurrentAddress().then((address) {
                                if (address != null) {
                                  setState(() {
                                    _locationTextController.text =
                                        '${_authData.PlaceName} \n ${_authData.shopAddress}';
                                  });
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content:
                                          Text(" unable to find Location")));
                                }
                              });
                            },
                          ),
                          labelText: 'Address',
                          // contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal)),
                          focusColor: Colors.teal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextFormField(
                      onChanged: (value) {
                        _diaglogTextController.text = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Business Dialogue';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.chat),
                          labelText: 'Business Dialogue',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  BorderSide(width: 2, color: Colors.teal)),
                          focusColor: Colors.teal),
                    ),
                  ),
                  RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                      onPressed: () {
                        if (_authData.isPicAvailable == true) {
                          if (_formkey.currentState.validate()) {
                            setState(() {
                              _isloading = true;
                            });
                            _authData
                                .registervendor(email, password)
                                .then((credential) {
                              if (credential.user.uid != null) {
                                uploadFile(_authData.image.path).then((url) {
                                  if (url != null) {
                                    _authData.saveDataToFirestore(
                                        url: url,
                                        shopName: shopName,
                                        mobile: mobile,
                                        dialog: _diaglogTextController.text);
                                    setState(() {
                                      _isloading = false;
                                    });

                                    Navigator.pushReplacementNamed(
                                        context, HomeScreen.id);
                                  } else {
                                    errorMessage(
                                        "Failed to Upload Shop Picture");
                                  }
                                });
                              } else {
                                errorMessage(_authData.error);
                              }
                            });
                          }
                        } else {
                          errorMessage("Shop profile picture to be needed");
                        }
                      },
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  Row(
                    children: [
                      FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.id);
                          },
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(text: '', children: [
                              TextSpan(
                                  text: 'Already have a account ? ',
                                  style: TextStyle(
                                    color: Colors.teal,
                                  )),
                              TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          )),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
