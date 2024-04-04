import 'dart:developer';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecashier/components/dialog.dart';
import 'package:flutter_ecashier/services/db.dart';

class DatasetPage extends StatefulWidget {
  const DatasetPage({super.key});

  @override
  State<DatasetPage> createState() => _DatasetPageState();
}

class _DatasetPageState extends State<DatasetPage> {
  List<Map<String, dynamic>> _menus = [];

  refresh() async {
    try {
      var data = await DatabaseHelper.getItems();
      setState(() {
        _menus = data;
      });
      log('$_menus');
    } catch (e) {
      ElegantNotification.error(
        title: const Text("Gagal"),
        description: const Text("Data gagal diambil"),
      ).show(context.mounted as BuildContext);
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseHelper.initizateDb().whenComplete(() async {
      refresh();
    });
  }

  @override
  void didUpdateWidget(DatasetPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  double availableScreenWidth = 0;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    availableScreenWidth = MediaQuery.of(context).size.width - 50;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          alignment: Alignment.bottomCenter,
          height: 170,
          decoration: BoxDecoration(color: Colors.blue.shade800),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "eCashier",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Made",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(.1)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(.1)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      size: 28,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            )
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(25),
            children: [
              const Text(
                "Daftar Menu",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              for (var item in _menus)
                buildProjectRow(item["id"], item["title"], item["description"],
                    item["price"]),
            ],
          ),
        )
      ]),
      floatingActionButton: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(color: Colors.white, spreadRadius: 7, blurRadius: 1)
        ]),
        child: FloatingActionButton(
          onPressed: () {
            BottomDialog().showBottomDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            refresh();
          },
          currentIndex: selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Daftar Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop_outlined),
              label: 'Pesanan',
            ),
          ]),
    );
  }

  Widget buildProjectRow(int id, String title, String description, int price) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute<void>(
        //   builder: (BuildContext context) => DatasetListPage(
        //     name: name,
        //   ),
        // ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 65,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(15)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.grey,
            ),
          )
        ]),
      ),
    );
  }
}
