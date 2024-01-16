import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:text_recognition/firebase_options.dart';

// Conexión a firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(renuevApp());
}

class renuevApp extends StatelessWidget {
  const renuevApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Creo la instancia de la DB
    final db = FirebaseFirestore.instance;
    // Selecciono la colección "people" para extraer todos los documentos
    final collection = db.collection("/people");
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Center(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: collection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final querySnapshot = snapshot.data!;
                  // Obtén todos los documentos de la colección
                  final documents = querySnapshot.docs;

                  print(documents);

                  // Puedes iterar a través de los documentos y mostrar la información que necesitas
                  final names = documents.map((doc) => doc['name']).join(', ');

                  return Text(names);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//------------------------ Scanner-----------------------

// void main() {
//   runApp(const MyApp());
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
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool textScanning = false;
//   File? imageFile;
//   String scannedText = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Text Recognition example"),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             margin: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (textScanning) const CircularProgressIndicator(),
//                 if (!textScanning && imageFile == null)
//                   Container(
//                     width: 300,
//                     height: 300,
//                     color: Colors.grey[300]!,
//                   ),
//                 if (imageFile != null) Image.file(imageFile!),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 5),
//                       padding: const EdgeInsets.only(top: 10),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.white,
//                           onPrimary: Colors.grey,
//                           shadowColor: Colors.grey[400],
//                           elevation: 10,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         onPressed: () {
//                           getImage(ImageSource.gallery);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(
//                             vertical: 5,
//                             horizontal: 5,
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.image,
//                                 size: 30,
//                               ),
//                               Text(
//                                 "Gallery",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 5),
//                       padding: const EdgeInsets.only(top: 10),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.white,
//                           onPrimary: Colors.grey,
//                           shadowColor: Colors.grey[400],
//                           elevation: 10,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         onPressed: () {
//                           getImage(ImageSource.camera);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(
//                             vertical: 5,
//                             horizontal: 5,
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.camera_alt,
//                                 size: 30,
//                               ),
//                               Text(
//                                 "Camera",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   child: Text(
//                     scannedText,
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void getImage(ImageSource source) async {
//     try {
//       final pickedImage = await ImagePicker().pickImage(source: source);
//       if (pickedImage != null) {
//         textScanning = true;
//         imageFile = File(pickedImage.path);
//         setState(() {});
//         getRecognisedText(imageFile!);
//       }
//     } catch (e, stackTrace) {
//       print("Error: $e");
//       print("Stack trace: $stackTrace");
//       textScanning = false;
//       imageFile = null;
//       scannedText = "Error occurred while scanning";
//       setState(() {});
//     }
//   }

//   Future<void> getRecognisedText(File image) async {
//     try {
//       final inputImage = InputImage.fromFilePath(image.path);
//       final textRecognizer = GoogleMlKit.vision.textRecognizer();

//       // final List<TextBlock> recognizedText =
//       //     (await textRecognizer.processImage(inputImage)).blocks;
//       final RecognizedText recognizedText =
//           await textRecognizer.processImage(inputImage);
//       textRecognizer.close();

//       setState(() {
//         scannedText = recognizedText.text;
//         textScanning = false;
//       });
//     } catch (e, stackTrace) {
//       print("Error: $e");
//       print("Stack trace: $stackTrace");

//       setState(() {
//         textScanning = false;
//         scannedText = "Error occurred while scanning";
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }
// }
