import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:vendor_app/services/firebase_services.dart';

class AddEditCoupan extends StatefulWidget {
  static const String id = 'addedit-coupan';
  final DocumentSnapshot documentSnapshot;

  const AddEditCoupan({Key key, this.documentSnapshot});

  @override
  _AddEditCoupanState createState() => _AddEditCoupanState();
}

class _AddEditCoupanState extends State<AddEditCoupan> {
  final _formkey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  DateTime _selectedDate = DateTime.now();
  var dateText = TextEditingController();
  var title = TextEditingController();
  var details = TextEditingController();
  var discountRate = TextEditingController();
  bool _active = false;

  _selectDate(context) async {
    final DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (dateTime != null && _selectedDate != dateTime) {
      setState(() {
        _selectedDate = dateTime;
        String formateDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
        dateText.text = formateDate;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    if (widget.documentSnapshot != null) {
      setState(() {
        title.text = widget.documentSnapshot.data()['title'];
        discountRate.text =
            widget.documentSnapshot.data()['discountRate'].toString();

        details.text = widget.documentSnapshot.data()['details'].toString();
        dateText.text =
            widget.documentSnapshot.data()['expiredate'].toDate().toString();
        _active = widget.documentSnapshot.data()['active'];
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text(
          'Coupans',
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: title,
                  decoration: InputDecoration(
                      labelText: 'Coupan Title',
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      hintText: 'Title',
                      labelStyle: TextStyle(color: Colors.teal),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(width: 2, color: Colors.red[700])),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 2, color: Colors.teal)),
                      focusColor: Colors.teal),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Coupan Title ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: discountRate,
                  decoration: InputDecoration(
                      labelText: 'Coupan Discount',
                      suffix: Text(
                        '%',
                        style: TextStyle(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      hintText: 'Discount',
                      labelStyle: TextStyle(color: Colors.teal),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(width: 2, color: Colors.red[700])),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 2, color: Colors.teal)),
                      focusColor: Colors.teal),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Coupan Discount ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: dateText,
                  decoration: InputDecoration(
                      labelText: 'Coupan Expirey Date',
                      suffixIcon: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Icon(
                          Icons.date_range_rounded,
                          color: Colors.teal,
                        ),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      hintText: 'Expirey Date',
                      labelStyle: TextStyle(color: Colors.teal),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(width: 2, color: Colors.red[700])),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 2, color: Colors.teal)),
                      focusColor: Colors.teal),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Coupan Date ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: details,
                  decoration: InputDecoration(
                      labelText: 'Coupan Details',
                      contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      hintText: 'Details',
                      labelStyle: TextStyle(color: Colors.teal),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(width: 2, color: Colors.red[700])),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 2, color: Colors.teal)),
                      focusColor: Colors.teal),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Coupan Details ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Coupan',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    FlutterSwitch(
                      width: 70.0,
                      inactiveText: _active.toString().toUpperCase(),
                      height: 25.0,
                      inactiveTextColor: Colors.white,
                      valueFontSize: 13.0,
                      toggleSize: 15.0,
                      value: _active,
                      activeTextColor: Colors.white,
                      borderRadius: 10.0,
                      padding: 4,
                      showOnOff: true,
                      activeColor: Colors.teal,
                      activeText: _active.toString().toUpperCase(),
                      onToggle: (val) {
                        setState(() {
                          _active = !_active;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                FlatButton(
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
                      EasyLoading.show(status: 'Please Wait..');
                      _services
                          .saveCoupan(
                              document: widget.documentSnapshot,
                              title: title.text.toUpperCase(),
                              details: details.text,
                              discountRate: int.parse(discountRate.text),
                              expiredate: _selectedDate,
                              active: _active)
                          .then((value) {
                        setState(() {
                          title.clear();
                          details.clear();

                          discountRate.clear();
                          _active = false;
                        });
                        EasyLoading.showSuccess('Saved Successfully');
                      });
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Apply',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.teal,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
