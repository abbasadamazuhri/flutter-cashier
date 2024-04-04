import 'package:flutter/material.dart';
import 'package:flutter_ecashier/pages/dataset.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  databaseFactoryOrNull = null;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await databaseFactory.deleteDatabase('ecashier.db');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DatasetPage(),
    );
  }
}
