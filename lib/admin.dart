import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/login_page.dart';
import 'package:flutter_app/scanner.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'gestion.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Admin"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Escanear Código QR",
                        style: TextStyle(
                            fontSize: 18.0, fontStyle: FontStyle.normal)))),
            const SizedBox(
              height: 30.0,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const gestion()));
                    },
                    child: const Text("Gestiona solicitudes de renovación",
                        style: TextStyle(
                            fontSize: 18.0, fontStyle: FontStyle.normal)))),
          ],
        ));
  }
}
