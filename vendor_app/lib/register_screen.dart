import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app/register_form.dart';
import 'package:vendor_app/widgets/image_picker_shop.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
  static const String id = 'register-screen';
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
              child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ImagePickerOfShop(),
                      RegistorForm(),
                    ],
                  ),
                ),
              ),
            ),
          )),
        ),
        ConnectionStatusBar(
          height: double.infinity,
          title: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                "images/connection_lost.png",
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 100,
                left: 30,
                child: FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () {},
                  child: Text("Retry".toUpperCase()),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
