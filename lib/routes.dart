import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/students/students_list_page.dart';
import 'pages/students/student_form_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (ctx) => LoginPage(),
  '/home': (ctx) => HomePage(),
  '/students': (ctx) => StudentsListPage(),
  '/students/new': (ctx) => StudentFormPage(),
};