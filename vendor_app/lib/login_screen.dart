import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/forget_password_screen.dart';
import 'package:vendor_app/home_screen.dart';
import 'package:vendor_app/providers/auth_provider.dart';
import 'package:vendor_app/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Icon icon;
  String email;
  String password;
  bool _visible = false;
  bool _isloading = false;
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    errorMessage(message) {
      return Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          Image.asset(
                            'images/enteraddress.png',
                            height: 100.0,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailTextController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Email';
                          }
                          final bool _isValid =
                              EmailValidator.validate(_emailTextController.text);
                          if (!_isValid) {
                            return 'invalid Email';
                          }
                          setState(() {
                            email = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Enter Email',
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.teal)),
                            focusColor: Colors.teal),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
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
                        obscureText: _visible == false ? true : false,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _visible
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _visible = !_visible;
                                });
                              },
                            ),
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Enter Password',
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.teal)),
                            focusColor: Colors.teal),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ResetPasswordScreen.id);
                            },
                            child: Text(
                              "Forget Password ?",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: _isloading
                                ? LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    backgroundColor: Colors.transparent,
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isloading = true;
                              });
                              _authData
                                  .loginvendor(email, password)
                                  .then((credential) {
                                if (credential != null) {
                                  setState(() {
                                    _isloading = false;
                                  });
                                  Navigator.pushReplacementNamed(
                                      context, HomeScreen.id);
                                } else {
                                  _isloading = false;
                                  EasyLoading.showError(_authData.error);

                                }
                              });
                            }
                            // else {
                            //   Scaffold.of(context)
                            //       .showSnackBar(SnackBar(content: Text(message)));
                            // }
                          },
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0))),
                      Row(
                        children: [
                          FlatButton(

                              padding: EdgeInsets.zero,
                              onPressed: (){

                            Navigator.pushReplacementNamed(context, RegisterScreen.id);
                          }, child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(

                              text: '',children: [
                                TextSpan(text: 'Don\'t have account ? ',style: TextStyle(color: Colors.teal,)),
                                TextSpan(text: 'Register',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold)),
                            ]
                            ),
                          )),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
