import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// PDF
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class gestion extends StatefulWidget {
  const gestion({Key? key}) : super(key: key);

  @override
  State<gestion> createState() => _gestionState();
}

class _gestionState extends State<gestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Gestión de Solicitudes"),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('EscanerBD')
          .where('estado', isEqualTo: 'En espera')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Extraer los documentos de la colección
        final documents = snapshot.data!.docs;

        if (documents.isEmpty) {
          return Center(
            child: Text('No hay documentos en espera'),
          );
        }

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            // Obtener los datos de cada documento
            final data = documents[index].data() as Map<String, dynamic>;

            // Acceder a los campos anidados
            final madre = data['madre'] as Map<String, dynamic>;
            final padre = data['padre'] as Map<String, dynamic>;

            // Obtener el ID del documento
            final documentId = documents[index].id;

            // Construir la interfaz de usuario utilizando los datos obtenidos
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35.0),

                _buildDataWidget("ID del documento: ", documents[index].id),
                _buildDataWidget("Nombre de la madre:", madre['nombre']),
                _buildDataWidget("Cédula de la madre:", madre['cedula']),
                _buildDataWidget("Fecha:", data['fecha']),
                _buildDataWidget("Ubicacion", data['ubicacion']),
                _buildDataWidget("Nombre:", data['nombre']),
                _buildDataWidget("Nombre del padre:", padre['nombre']),
                _buildDataWidget("Cédula del padre:", padre['cedula']),
                _buildDataWidget("Estado de la solicitud", data['estado']),
                _buildButtonRow(documents[index].reference,
                    data), // Pasar los datos del documento
                Divider(), // Separador entre cada documento
                SizedBox(height: 35.0),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDataWidget(String title, String data) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 20.0), // Padding horizontal para centrar los datos
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text(data),
        ],
      ),
    );
  }

  Widget _buildButtonRow(
      DocumentReference documentReference, Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 20.0, vertical: 10.0), // Padding para los botones
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceEvenly, // Distribución equitativa de los botones
        children: [
          ElevatedButton(
            onPressed: () {
              _updateDocumentStatus(documentReference, 'Aceptado', data);
            },
            child: Text('Aceptar'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateDocumentStatus(documentReference, 'Rechazado', data);
            },
            child: Text('Rechazar'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateDocumentStatus(DocumentReference documentReference,
      String status, Map<String, dynamic> data) async {
    try {
      await documentReference.update({'estado': status});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Estado actualizado a $status')));

      // Si el estado es 'Aceptado', redirigir a la pantalla de detalles
      if (status == 'Aceptado') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentDetailsScreen(
              documentData: data, // Pasar los datos del documento
              documentId: documentReference.id, // Pasar el ID del documento
            ),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el estado')));
    }
  }
}

class DocumentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> documentData;
  final String documentId;

  DocumentDetailsScreen({required this.documentData, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Documento'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await _downloadPDF(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ID del documento: $documentId"),
            SizedBox(height: 20),
            // Mostrar los datos del documento aquí
            // Por ejemplo:
            Text("Nombre de la madre: ${documentData['madre']['nombre']}"),
            Text("Cédula de la madre: ${documentData['madre']['cedula']}"),
            Text("Fecha: ${documentData['fecha']}"),
            // Agrega más campos según tu estructura de datos
            SizedBox(height: 20),
            Text("Información adicional..."),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = await _generatePDF();
    final directory =
        await getExternalStorageDirectory(); // Cambiar a la carpeta de descargas
    final file = File('${directory!.path}/Renovacion_Partida.pdf');
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF descargado correctamente en ${file.path}'),
      ),
    );
  }

  Future<pw.Document> _generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text("PARTIDA DE NACIMIENTO"),
                pw.SizedBox(height: 20),
                pw.Text(
                    "Segun la Resolucion numero 1165 con fecha 22-07-03 hago consta que hoy ${documentData['fecha']}, me ha sido presentado ante su despacho, un recien nacido de sexo ${documentData['sexo']} por el Ciudadano ${documentData['padre']['nombre']}; venezolano, casado de ${documentData['padre']['edad']} años con cedula de identidad ${documentData['padre']['cedula']} y expuso que el bebe que presenta nacio el dia ${documentData['fecha']} en ${documentData['ubicacion']}; y lleva por nombre ${documentData['nombre']}. Que es su lujo y de su esposa: ${documentData['madre']['nombre']}, venezolana, casada de ${documentData['madre']['edad']}; con cedula de identidad ${documentData['madre']['cedula']}. El presente certificado se expide a petición del interesado, con la finalidad de acreditar su identidad, para los efectos legales oportunos."),
              ],
            ),
          );
        },
      ),
    );
    return pdf;
  }
}
