import 'package:flutter/material.dart';
import 'package:flutter_app/page02.dart';

void main() => runApp(renuevApp());

// Widget que hace que corra la Aplicacion
class renuevApp extends StatelessWidget {
  const renuevApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: "RenuevApp", home: home());
  }
}

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
            title: Center(
          child: Text("RenuevApp"),
        )),
        body: inicio(context));
  }
}

Widget inicio(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Texto principal
      Center(
          child: Text("Bienvenido a RenuevApp",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold))),

      // Para dar un espaciado entre Widgets
      SizedBox(
        height: 30.0,
      ),

      // Logo de la Aplicacion
      Center(child: Image.asset("assets/Logo.PNG", fit: BoxFit.scaleDown)),
      SizedBox(
        height: 50.0,
      ),

      // Botón de Renovar
      ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page02()));
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(25.0),
          ),
          child: Text("Renovar Acta de Nacimiento",
              style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal))),

      SizedBox(
        height: 20.0,
      ),

      // Botón de AlertDialog de cómo funciona la aplicación
      ElevatedButton(
          onPressed: () {
            instrucciones(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(25.0),
            fixedSize: Size(280, 55),
          ),
          child: Text("Instrucciones",
              style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal)))
    ],
  );
}

void instrucciones(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext) {
        return AlertDialog(
          title: Text("Instrucciones"),
          content: Text(
              "1)Tener en la galeria la partida de nacimiento a renovar\n\n2)Seleccionar la imagen de la galeria (debe tener buena calidad)\n\n3)Esperar que procese la imagen\n\n4)Si la imagen se proceso con éxito se generará una partida totalmente renovada con un código QR único para el usuario",
              style: TextStyle(wordSpacing: 2.0)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Entiendo"))
          ],
        );
      });
}
