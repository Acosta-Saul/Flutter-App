import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class page02 extends StatefulWidget {
  const page02({Key? key}) : super(key: key);

  @override
  _page02State createState() => _page02State();
}

class _page02State extends State<page02> {
  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Renovar Acta"),
      ),
      body: cargarFoto(),
    );
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _pickedImage = pickedFile;
      }
    });
  }

  Widget cargarFoto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_pickedImage != null) // Verifica si hay una imagen seleccionada
          Image.file(
            // Muestra la imagen seleccionada
            File(_pickedImage!.path),
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        const Center(
          child: Text(
            "Seleccione una imagen de la galería",
            style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal),
          ),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(25.0),
            fixedSize: const Size(280, 55),
          ),
          onPressed: () {
            _seleccionarImagen(ImageSource.gallery); // Desde la galería
          },
          child: const Text(
            "Cargar Imagen",
            style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal),
          ),
        ),
        const SizedBox(height: 20.0),
        Center(
          child: IconButton(
            onPressed: () {
              _mostrarSugerencia(context);
            },
            icon: const Icon(Icons.contact_support_outlined),
          ),
        )
      ],
    );
  }

  void _mostrarSugerencia(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext) {
        return AlertDialog(
          title: const Text("Recomendacion"),
          content: const Text(
            "La imagen a subir debe estar completamente legible y enfocada, todos los campos deben poder leerse sin problemas para procesar de manera correcta la imagen.",
            style: TextStyle(wordSpacing: 2.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Entiendo"),
            )
          ],
        );
      },
    );
  }
}
