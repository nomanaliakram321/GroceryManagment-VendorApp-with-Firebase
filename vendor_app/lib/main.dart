import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendor_app/add_edit_coupan.dart';
import 'package:vendor_app/add_new_productscreen.dart';
import 'package:vendor_app/coupans_screen.dart';
import 'package:vendor_app/forget_password_screen.dart';
import 'package:vendor_app/home_screen.dart';
import 'package:vendor_app/login_screen.dart';
import 'package:vendor_app/providers/auth_provider.dart';
import 'package:vendor_app/providers/order_provider.dart';
import 'package:vendor_app/providers/product_provider.dart';
import 'package:vendor_app/register_screen.dart';
import 'package:vendor_app/reports_screen.dart';
import 'package:vendor_app/splash_screen.dart';

import 'banner_screen.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider()),
        Provider(create: (_) => ProductProvider()),
        Provider(create: (_) => OrderProvider()),
      ],
      child: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(
          primaryColor: Color(0xFF009688),
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
          AddNewProduct.id: (context) => AddNewProduct(),
          BannerScreen.id: (context) => BannerScreen(),
          ReportScreen.id: (context) => ReportScreen(),
          CoupanScreen.id: (context) => CoupanScreen(),
          AddEditCoupan.id: (context) => AddEditCoupan(),
        });
  }
}
