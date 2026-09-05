import 'package:flutter/material.dart';
import 'pages/login/login_page.dart';
import 'pages/home/home_page.dart';
import 'pages/students/students_list_page.dart';
import 'pages/students/student_form_page.dart';
import 'pages/settings/settings_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (ctx) => const LoginPage(),
  '/home': (ctx) => const HomePage(),
  '/students': (ctx) => const StudentsListPage(),
  '/students/new': (ctx) => const StudentFormPage(),
  '/settings': (ctx) => const SettingsPage(),
};