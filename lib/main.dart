import 'package:flutter/material.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(renuevApp());
}

// Widget que hace que corra la Aplicacion
class renuevApp extends StatelessWidget {
  const renuevApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "RenuevApp",
        home: LoginPage());
  }
}
