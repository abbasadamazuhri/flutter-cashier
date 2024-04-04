import 'dart:developer';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecashier/services/db.dart';

class BottomDialog {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  String error = "";
  String title = "";
  String description = "";
  String price = "";

  showBottomDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: _buildDialogContent(context),
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
  }

  Widget _buildDialogContent(BuildContext context) {
    return IntrinsicHeight(
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
                  'Formulir Menu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0.4)),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                          borderSide:
                              BorderSide(style: BorderStyle.none, width: 0)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0.4)),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                          borderSide:
                              BorderSide(style: BorderStyle.none, width: 0)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0.4)),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Harga (Rp)',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(style: BorderStyle.none, width: 0)),
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
                    borderRadius: BorderRadius.all(Radius.circular(8)),
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
                            description: const Text("Data berhasil disimpan"),
                          ).show(context);
                        } catch (e) {
                          ElegantNotification.error(
                            title: const Text("Gagal"),
                            description: const Text("Data gagal disimpan"),
                          ).show(context);
                          log('err: $e');
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
    );
  }
}
