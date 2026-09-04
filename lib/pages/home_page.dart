import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Euro Tech!'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          )
        ],
      ),
      body: Center(
        child: Text('Olá, ${auth.user?.name ?? 'Usuário'}\nDashboard placeholder', textAlign: TextAlign.center),
      ),
      bottomNavigationBar: BottomNav(selectedIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/students'),
        child: Icon(Icons.group),
      ),
    );
  }
}