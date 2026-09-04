import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  const BottomNav({this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Turmas'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Plataformas'),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      ],
      onTap: (i) {
        // Exemplo: navegação baseada em índice
        switch (i) {
          case 0:
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case 1:
            Navigator.of(context).pushReplacementNamed('/students');
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Navegar para índice $i')));
        }
      },
    );
  }
}