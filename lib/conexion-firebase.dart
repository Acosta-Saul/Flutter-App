import 'package:flutter/material.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos desde Firestore'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
            widgets.add(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text('Datos de la Madre:'),
                  Text('Cédula: ${madre['Cedula']}'),
                  Text('Nombre: ${madre['Nombre']}'),
                  SizedBox(height: 20),
                  Text('Hijo: ' + nombre),
                  Text('Fecha de Nacimiento: ' + fecha),
                  SizedBox(height: 20),
                  Text(
                    'Cómo tan muchacho, yo lo veo a utede mui vien',
                  ),
                  SizedBox(height: 20),
                  Text('Datos del Padre:'),
                  Text('Cédula: ${padre['Cedula']}'),
                  Text('Nombre: ${padre['Nombre']}'),
                  SizedBox(height: 20),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              children: widgets,
            ),
          );
        },
      ),
    );
  }
}
