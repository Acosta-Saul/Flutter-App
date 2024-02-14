import 'dart:convert'; //Para convertir de map a JSON
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: const Scanner(),
//     );
//   }
// }

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);
  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool textScanning = false;
  File? imageFile;
  String scannedText = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("RenuevApp"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 40.0,
          ),
          Center(
            child: Text("Cargar una Partida para Renovar"),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (textScanning) const CircularProgressIndicator(),
                    if (!textScanning && imageFile == null)
                      Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey[300]!,
                      ),
                    if (imageFile != null) Image.file(imageFile!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(235, 255, 234, 203),
                              onPrimary: Colors.grey,
                              shadowColor: Colors.grey[400],
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  Text(
                                    "Galería",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600], //Blanco ostra
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(235, 255, 234, 203),
                              onPrimary: Colors.grey,
                              shadowColor: Color.fromARGB(235, 255, 234, 203),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              getImage(ImageSource.camera);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                  Text(
                                    "Cámara",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Text(
                        scannedText,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: IconButton(
                onPressed: () {
                  _mostrarSugerencia(context);
                },
                icon: Icon(Icons.contact_support_outlined)),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('EscanerBD').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final documentos = snapshot.data!.docs;
              List<Widget> widgets = [];

              for (final documento in documentos) {
                final data = documento.data() as Map<String, dynamic>;

                var id = documento.id;
                var madre = {
                  'Cedula': data['madre']['cedula'],
                  'Nombre': data['madre']['nombre'],
                };
                var padre = {
                  'Cedula': data['padre']['cedula'],
                  'Nombre': data['padre']['nombre'],
                };
                var nombre = data['nombre'];
                var fecha = data['fecha'];

                print(scannedText);

                // Para probar si funciona la condicional
                if (scannedText.contains(madre['Cedula']) &&
                    scannedText.contains(padre['Cedula']) &&
                    scannedText.contains(nombre)) {
                  print('Si esta la cedula de los padres y el nombre del hijo');
                }

                /* Si el texto scaneado coincide con los datos de la BD entonces genera un QR único para dicho registro */
                if (scannedText.contains(madre['Cedula']) &&
                    scannedText.contains(padre['Cedula']) &&
                    scannedText.contains(nombre)) {
                  //Pasa de map a JSON
                  String jsonData = json.encode(data);
                  widgets.add(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        Text('ID registro: ' + id),
                        SizedBox(height: 40),
                        Text('Datos de la Madre:'),
                        Text('Cédula: ${madre['Cedula']}'),
                        Text('Nombre: ${madre['Nombre']}'),
                        SizedBox(height: 20),
                        Text('Hijo: ' + nombre),
                        Text('Fecha de Nacimiento: ' + fecha),
                        SizedBox(height: 20),
                        Text('Datos del Padre:'),
                        Text('Cédula: ${padre['Cedula']}'),
                        Text('Nombre: ${padre['Nombre']}'),
                        SizedBox(height: 20),
                        QrImage(
                          data: jsonData,
                          version: QrVersions.auto,
                          size: 200.0,
                        )
                      ],
                    ),
                  );
                  break;
                }
              }

              return Center(
                child: Column(
                  children: widgets,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = File(pickedImage.path);
        setState(() {});
        getRecognisedText(imageFile!);
      }
    } catch (e, stackTrace) {
      print("Error: $e");
      print("Stack trace: $stackTrace");
      textScanning = false;
      imageFile = null;
      scannedText = "Error occurred while scanning";
      setState(() {});
    }
  }

  Future<void> getRecognisedText(File image) async {
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      textRecognizer.close();

      setState(() {
        scannedText = recognizedText.text;

        textScanning = false;
      });
    } catch (e, stackTrace) {
      print("Error: $e");
      print("Stack trace: $stackTrace");
      setState(() {
        textScanning = false;
        scannedText = "Error occurred while scanning";
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }
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
