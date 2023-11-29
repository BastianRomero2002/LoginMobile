import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

class UbicacionPage extends StatefulWidget {
  @override
  _UbicacionPageState createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  //late GoogleMapController mapController;

  //final LatLng _center = const LatLng(45.521563, -122.677433);

  //void _onMapCreated(GoogleMapController controller) {
    //mapController = controller;
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Ubicación con Mapa'),
      ),
      //body: GoogleMap(
        //onMapCreated: _onMapCreated,
        //initialCameraPosition: CameraPosition(
          //target: LatLng(37.42796133580664, -122.085749655962),
          //zoom: 11.0,
        //),
      //),
    );
  }
}
