import 'dart:developer';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecashier/services/db.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  double availableScreenWidth = 0;
  int _selectedIndex = 0;
  String error = "";
  String title = "";
  String description = "";
  String price = "";
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
  Widget build(BuildContext context) {
    availableScreenWidth = MediaQuery.of(context).size.width - 50;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          alignment: Alignment.bottomCenter,
          height: 170,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.black, Colors.blue]),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kasir",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  "Aplikasi POS",
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
              ],
            )
          ]),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 25, right: 25),
                child: const Text(
                  "Daftar Menu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              for (var item in _menus)
                Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        dismissible: null,
                        children: [
                          SlidableAction(
                              flex: 1,
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              onPressed: (context) {}),
                          SlidableAction(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              onPressed: (context) async {
                                try {
                                  await DatabaseHelper.deleteItem(item["id"]);
                                  ElegantNotification.success(
                                    title: const Text("Berhasil"),
                                    description:
                                        const Text("Data berhasil dihapus"),
                                    // ignore: use_build_context_synchronously
                                  ).show(context);
                                  refresh();
                                } catch (e) {
                                  ElegantNotification.error(
                                    title: const Text("Gagal"),
                                    description:
                                        const Text("Data gagal dihapus"),
                                    // ignore: use_build_context_synchronously
                                  ).show(context);
                                  log('$e');
                                }
                              })
                        ],
                      ),
                      child: ListTile(
                        title: Text(item["title"]),
                        subtitle: Text(item["description"]),
                        trailing: Text(item["price"].toString()),
                      ),
                    )),
            ],
          ),
        )
      ]),
      floatingActionButton: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(color: Colors.white, spreadRadius: 7, blurRadius: 1)
        ]),
        child: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          onPressed: () {
            showGeneralDialog(
              barrierLabel: "showGeneralDialog",
              barrierDismissible: true,
              barrierColor: Colors.black.withOpacity(0.6),
              transitionDuration: const Duration(milliseconds: 400),
              context: context,
              pageBuilder: (context, _, __) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: IntrinsicHeight(
                    child: Container(
                      width: double.maxFinite,
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Material(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              const Text(
                                'Tambah Data',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.grey.withOpacity(0.4)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: TextFormField(
                                  controller: titleController,
                                  decoration: const InputDecoration(
                                    hintText: 'Nama',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.none, width: 0)),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.grey.withOpacity(0.4)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: TextFormField(
                                  controller: descriptionController,
                                  decoration: const InputDecoration(
                                    hintText: 'Deskripsi',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.none, width: 0)),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.grey.withOpacity(0.4)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: TextFormField(
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'Harga (Rp)',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.none, width: 0)),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 50,
                                width: double.maxFinite,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: RawMaterialButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        await DatabaseHelper.insertItem(
                                            titleController.text,
                                            descriptionController.text,
                                            int.parse(priceController.text));
                                        ElegantNotification.success(
                                          title: const Text("Berhasil"),
                                          description: const Text(
                                              "Data berhasil disimpan"),
                                          // ignore: use_build_context_synchronously
                                        ).show(context);
                                        refresh();
                                      } catch (e) {
                                        ElegantNotification.error(
                                          title: const Text("Gagal"),
                                          description:
                                              const Text("Data gagal disimpan"),
                                          // ignore: use_build_context_synchronously
                                        ).show(context);
                                        log('$e');
                                      }
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Simpan Data',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              transitionBuilder: (_, animation1, __, child) {
                return SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                  ).animate(animation1),
                  child: child,
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            refresh();
          },
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              ),
              label: 'Daftar Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shop_outlined,
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              ),
              label: 'Pesanan',
            ),
          ]),
    );
  }
}
