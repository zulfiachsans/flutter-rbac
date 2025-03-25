import 'package:flutter/material.dart';
import 'package:flutter_rbac/presentation/pages/home_page.dart';
import 'package:flutter_rbac/presentation/pages/order_page.dart';
import 'package:flutter_rbac/presentation/pages/profile_page.dart';
import 'package:flutter_rbac/utils/colors.dart';

class NavbarScreen extends StatefulWidget {
  final String username;

  const NavbarScreen({super.key, required this.username});

  @override
  _NavbarScreenState createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int _selectedIndex = 0;

  // 🔴 Daftar Halaman dalam Navbar
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(
        username: widget.username,
        onTabChange: _onItemTapped,
      ), // 🔴 HomePage dengan username
      OrderPage(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[
          _selectedIndex], // 🔴 Menampilkan halaman sesuai tab yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Pemesanan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
