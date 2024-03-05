import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/login_page.dart';
import 'package:flutter_app/scanner.dart';

// Widget Home contiene la estructura básica de una aplicación móvil (Scaffold)
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Center(
            child: Text("RenuevApp"),
          ),
          actions: [
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
                //Boton para cerrar sesion y que te redirija al login
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15.0),
                  fixedSize: const Size(280, 55),
                ),
                child: const Text("Cerrar sesion",
                    style:
                        TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal)))
          ],
        ),
        body: inicio(context));
  }
}

Widget inicio(context) {
  var elevatedButton = ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Scanner()));
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(25.0),
      ),
      child: const Text("Renovar Acta de Nacimiento",
          style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal)));

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Texto principal
      const Center(
          child: Text("Bienvenido a RenuevApp",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold))),
      // Para dar un espaciado entre Widgets
      const SizedBox(
        height: 30.0,
      ),
      // Logo de la Aplicacion
      Center(child: Image.asset("assets/Logo.PNG", fit: BoxFit.scaleDown)),
      const SizedBox(
        height: 50.0,
      ),
      // Botón de Renovar
      elevatedButton,
      const SizedBox(
        height: 20.0,
      ),
      // Botón de AlertDialog de cómo funciona la aplicación
      ElevatedButton(
          onPressed: () {
            instrucciones(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
            fixedSize: const Size(280, 55),
          ),
          child: const Text("Instrucciones",
              style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal)))
    ],
  );
}

void instrucciones(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext) {
        return AlertDialog(
          title: const Text("Instrucciones"),
          content: const Text(
              "1)Tener en la galeria la partida de nacimiento a renovar\n\n2)Seleccionar la imagen de la galeria (debe tener buena calidad)\n\n3)Esperar que procese la imagen\n\n4)Si la imagen se proceso con éxito se generará una partida totalmente renovada con un código QR único para el usuario",
              style: TextStyle(wordSpacing: 2.0)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Entiendo"))
          ],
        );
      });
}
