import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'routes.dart';
import 'pages/login/login_page.dart';
import 'pages/home/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return MaterialApp(
      title: 'Euro Tech!',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: appRoutes,
      home: auth.isLogged ? HomePage() : LoginPage(),
    );
  }
}