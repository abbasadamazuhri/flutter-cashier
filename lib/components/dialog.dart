import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ecashier/models/menu.dart';
import 'package:flutter_ecashier/services/sqlite.dart';

class BottomDialog {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String error = "";
  String title = "";
  String description = "";

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
          child: _buildDialogContent(),
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

  Widget _buildDialogContent() {
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
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Judul',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib diisi';
                    }
                    return null;
                  },
                  // onChanged: (value) {
                  //   setState(() => title = value);
                  // },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Deskripsi',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Wajib diisi';
                    }
                    return null;
                  },
                  // onChanged: (value) {
                  //   setState(() => description = value);
                  // },
                ),
                const SizedBox(height: 16),
                Container(
                  height: 40,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: RawMaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> data = {
                          title: titleController.text,
                          description: descriptionController.text
                        };
                        log('data: $data');
                        dynamic result =
                            await SqliteService.createItem(data as Menu);
                        if (result == null) {}
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Simpan Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Column(
          //   children: [
          //     const SizedBox(height: 16),
          //     _buildTitle(),
          //     const SizedBox(height: 16),
          //     _buildTextField(),
          //     const SizedBox(height: 16),
          //     _buildContinueButton(),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Formulir Menu',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.grey.withOpacity(0.4)),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: const TextField(
        decoration: InputDecoration.collapsed(hintText: 'Nama'),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      height: 40,
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: RawMaterialButton(
        onPressed: () {
          // Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Center(
          child: Text(
            'Simpan Data',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
