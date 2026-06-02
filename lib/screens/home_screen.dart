import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safechemicals/services/database_service.dart';
import 'package:safechemicals/screens/product_list_screen.dart';
import 'package:safechemicals/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeChemicals'),
        elevation: 4,
      ),
      body: _selectedIndex == 0 
          ? const ProductListScreen() 
          : const SearchScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.list),
            icon: Icon(Icons.list_outlined),
            label: 'Productos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Buscar',
          ),
        ],
      ),
    );
  }
}
