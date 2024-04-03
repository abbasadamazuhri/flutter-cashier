import 'package:flutter/material.dart';
import 'package:flutter_ecashier/pages/dataset/home.dart';
import 'package:flutter_ecashier/pages/order/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.dataset_outlined),
                  text: "Daftar Menu",
                ),
                Tab(
                  icon: Icon(Icons.shop_outlined),
                  text: "Buat Pesanan",
                ),
              ],
            ),
            title: const Text('eCashier'),
            backgroundColor: Colors.black,
          ),
          body: const TabBarView(
            children: [
              DatasetPage(),
              OrderPage(),
            ],
          ),
        ),
      ),
    );
  }
}
