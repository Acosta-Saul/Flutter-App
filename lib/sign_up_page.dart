import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/firebase_auth_services.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter_app/login_page.dart';
import 'package:flutter_app/form_container_widget.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_firebase/global/common/toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("SignUp"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Username",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _signUp,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: isSigningUp
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 248, 203, 203),
                                  fontWeight: FontWeight.bold),
                            )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿Ya tienes una cuenta?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    var usuario = {
      'name': username,
      'email': email,
      'password': password,
      'rol': 'Usuario'
    };

    // Genera la instancia de la base de datos para comparar el email del usuario
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('Usuarios').get();
      var bandera = 'false';
      // Iterar sobre los documentos de la colección
      querySnapshot.docs.forEach((doc) {
        // Obtener los datos de cada documento
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        // Acceder a los campos específicos (por ejemplo, 'nombre' y 'correo')
        String nombre = userData['name'];
        String correo = userData['email'];

        // Ya existe el correo en la BD
        if (email == correo) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('El correo ya existe, intente con otro'),
              duration: Duration(seconds: 10), // Duración del mensaje
              backgroundColor: Color.fromARGB(255, 188, 0, 53),
            ),
          );
          bandera = 'true';
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
              (route) => false);
        }
      });

      if (bandera == 'false') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registro éxitoso'),
            duration: Duration(seconds: 10), // Duración del mensaje
            backgroundColor: Color.fromARGB(255, 2, 162, 45),
          ),
        );
        // Agregar el nuevo usuario a la colección "Usuarios"
        firestore.collection('Usuarios').add(usuario).then((value) {
          print('Usuario agregado con ID: ${value.id}');

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => home()),
              (route) => false);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '!Ooups¡, ocurrió un error, vuelva a intentarlo o intentelo más tarde'),
              duration: Duration(seconds: 10), // Duración del mensaje
              backgroundColor: Color.fromARGB(255, 188, 0, 53),
            ),
          );
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
              (route) => false);
          print('Error al agregar usuario: $error');
        });
      }
    } catch (e) {
      print('Error al obtener datos: $e');
    }
  }
}

// Esta función obtiene todos los documentos de la colección Usuarios de Firebase
