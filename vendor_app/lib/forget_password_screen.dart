import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/login_screen.dart';
import 'package:vendor_app/providers/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'forgetpasswordscreen-screen';
  ResetPasswordScreen({Key key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String email;
  bool _isloading = false;
  var _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
        body: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    FlatButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isloading = true;
                            });
                            _authData.resetPassword(email);

                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Please Check Your Email')));

                          }
                          Navigator.pushReplacementNamed(context, LoginScreen.id);
                        },
                        child: _isloading
                            ? LinearProgressIndicator()
                            : Text('Reset Password'),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)))
                  ],
                ),
              ),
            )),
      );

  }
}
