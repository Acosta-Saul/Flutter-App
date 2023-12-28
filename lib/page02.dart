import 'package:flutter/material.dart';

class page02 extends StatelessWidget {
  const page02({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Renovar Acta"),
      ),
      body: cargarFoto(context),
    );
  }
}

Widget cargarFoto(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
          child: Text("Seleccione una imagen de la galeria",
              style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal))),

      SizedBox(
        height: 20.0,
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(25.0),
          fixedSize: Size(280, 55),
        ),
        // Aqui deberia de abrir la galeria para seleccionar la imagen de la partida
        // de nacimiento que será procesada por la IA para extraer los Datos,
        // almacenarlos en una Estructura de Datos y posterior a ello realizar la busqueda
        // en la Base de Datos para verificar si dicha partida existe en la Base de Datos
        // y así el usuario pueda renovar la partida que cargo.
        onPressed: () {},
        child: Text("Cargar Imagen",
            style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal)),
      ),

      SizedBox(
        height: 20.0,
      ),
      //AlertDialog para recomendar al Usuario

      Center(
        child: IconButton(
            onPressed: () {
              _mostrarSugerencia(context);
            },
            icon: Icon(Icons.contact_support_outlined)),
      )
    ],
  );
}

void _mostrarSugerencia(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext) {
        return AlertDialog(
          title: Text("Recomendacion"),
          content: Text(
              "La imagen a subir debe estar completamente legible y enfocada, todos los campos deben poder leerse sin problemas para procesar de manera correcta la imagen.",
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
