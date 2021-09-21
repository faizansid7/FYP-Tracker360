import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker360/Firebase/auth.dart';
import 'package:tracker360/driver_provider.dart';
import 'package:tracker360/models/user.dart';
import 'package:tracker360/routs.dart';
import 'package:tracker360/screens/splash/splash_screen.dart';
import 'package:tracker360/theme.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tracker 360',
          theme: theme(),
          home: SplashScreen(),
          routes: routes,
        ),
      ),
    );
  }
}
