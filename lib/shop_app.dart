import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/auth_provider.dart';
import 'routes.dart';
import 'screens/auth_screen.dart';
import 'screens/product_list_screen.dart';

class ShopApp extends StatelessWidget {
  // This widget is the root of your application.
/*
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) => MaterialApp(
        title: 'Udemy Shop',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: "Lato",
            textTheme: ThemeData.light().textTheme.copyWith()),
        home: auth.isLoggedIn
            ? ProductListScreen()
            : FutureBuilder(
                future: auth.autoLogin(),
                builder: (c, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : AuthScreen(),
              ),
        routes: routes,
      ),
    );
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Udemy Shop',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: "Lato",
          textTheme: ThemeData.light().textTheme.copyWith()),
      home: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => auth.isLoggedIn
            ? ProductListScreen()
            : FutureBuilder(
                future: auth.autoLogin(),
                builder: (c, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : AuthScreen(),
              ),
      ),
      routes: routes,
    );
  }
}
