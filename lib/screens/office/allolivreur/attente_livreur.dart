// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class DeliveryMapPage extends StatefulWidget {
//   @override
//   _DeliveryMapPageState createState() => _DeliveryMapPageState();
// }

// class _DeliveryMapPageState extends State<DeliveryMapPage> {
//   GoogleMapController? mapController;
//   final LatLng initialPosition = LatLng(12.9716, 77.5946); // Coordonnées initiales de la carte

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Suivi du livreur'),
//       ),
//       body: GoogleMap(
//         onMapCreated: (controller) {
//           setState(() {
//             mapController = controller;
//           });
//         },
//         initialCameraPosition: CameraPosition(
//           target: initialPosition,
//           zoom: 15.0,
//         ),
//       ),
//     );
//   }
// }
