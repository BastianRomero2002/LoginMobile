import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:login1/ubicacion.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

import 'CrudPage.dart';
import 'login_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String ipAddress = 'Cargando...';

  @override
  void initState() {
    super.initState();
    // asincrónico desde initState
    _initializeWelcomePage();
  }

  Future<void> _initializeWelcomePage() async {
    // temporizador de 10 segundos
    Future.delayed(const Duration(seconds: 100), () {
      // Eliminado el llamado a _updateConectadoToZero()
      _navigateToLoginPage();
    });

    // la inicialización adicional asíncrona aquí
    //await _getIPAddress();
  }

  void _navigateToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void _navigateToCrud() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrudPage(),
      ),
    );
  }

  Future<void> _showBatteryPercentage() async {
    final Battery battery = Battery();
    final int batteryLevel = await battery.batteryLevel;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Porcentaje de la batería'),
          content: Text('El porcentaje actual de la batería es: $batteryLevel%'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToUbicacion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UbicacionPage(),
      ),
    );
  }

  Future<void> _getIPAddress() async {
    try {
      String? ipAddressResult = await WifiInfo().getWifiIP();

      setState(() {
        ipAddress = ipAddressResult ?? 'Dirección IP no disponible';
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Dirección IP'),
            content: Text('La dirección IP actual es: $ipAddress'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error al obtener la dirección IP: $e');
    }
  }

Future<void> _showPhoneNumber() async {
  final phoneNumber = 'tel:+77759691';
  String whatsappUrl = "whatsapp://send?phone=$phoneNumber";
  launch(whatsappUrl);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _navigateToCrud();
              },
              child: const Text(
                'Ir a CRUD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 139, 129, 31),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(15.0),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Regresar',
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showBatteryPercentage();
              },
              child: const Text(
                'Porcentaje de Batería',
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _navigateToUbicacion();
              },
              child: const Text(
                'Ir a Ubicación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(15.0),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _getIPAddress();
              },
              child: const Text(
                'Mostrar IP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(15.0),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showPhoneNumber();
              },
              child: const Text(
                'Ir a Whatsapp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 162, 87, 173),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
