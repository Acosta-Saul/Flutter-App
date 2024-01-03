import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getPeople() async {
  List<Map<String, dynamic>> people = [];

  CollectionReference collectionReferencePeople =
      FirebaseFirestore.instance.collection('people');

  QuerySnapshot queryPeople = await collectionReferencePeople.get();

  queryPeople.docs.forEach((documento) {
    Map<String, dynamic>? data = documento.data() as Map<String, dynamic>?;
    if (data != null && data.containsKey('name') && data['name'] != null) {
      people.add(data);
    }
  });
  return people;
}
