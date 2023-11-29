import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';  // Asegúrate de tener esta importación
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Llama a la función para solicitar permisos al iniciar
  }

  // Función para solicitar permisos
  Future<void> _requestPermissions() async {
    // Pide permiso de teléfono
    var status = await Permission.phone.request();

    if (status.isGranted) {
      print('Permiso de teléfono concedido');
    } else {
      print('Permiso de teléfono denegado');
      // Puedes mostrar un mensaje al usuario explicando por qué necesitas el permiso.
    }
  }

  Future<Map<String, dynamic>> _authenticate(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/web_service/connection.php'),
        body: {'user': username, 'pass': password},
      );

      if (response.statusCode == 200) {
        var user = json.decode(response.body);

        if (user != null) {
          print('Usuario autenticado: $username');

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);

          return {'success': true, 'message': '¡Inicio de sesión exitoso!'};
        } else {
          print('Usuario o contraseña incorrectos');
          return {'success': false, 'message': 'Usuario o contraseña incorrectos'};
        }
      } else {
        print('Error en la solicitud al web service');
        return {'success': false, 'message': 'Error en la solicitud al web service'};
      }
    } catch (e) {
      print('Error en la conexión al web service: $e');
      return {'success': false, 'message': 'Error en la conexión al web service'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomePage(),
                    ),
                  );
                },
                child: const Text(
                  'Ir a la Página de Bienvenida',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.all(15.0),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final username = _usernameController.text.trim();
                  final password = _passwordController.text;

                  if (username.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, complete todos los campos')),
                    );
                    return;
                  }

                  var result = await _authenticate(username, password);

                  if (result['success']) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomePage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario o contraseña incorrectos')),
                    );
                  }
                },
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 1, 127, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.all(15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
