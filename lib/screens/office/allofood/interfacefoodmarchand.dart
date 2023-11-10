import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InterfaceFoodMarchand extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Commandes'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('marchand')
            .doc(user?.uid)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Aucune donnée de marchand disponible.'),
            );
          } else {
            var marchandData = snapshot.data!.data() as Map<String, dynamic>;
            var commandes = marchandData['commande'] as List<dynamic>;

            return ListView.builder(
              itemCount: commandes.length,
              itemBuilder: (context, index) {
                var commandData = commandes[index] as Map<String, dynamic>;
                var commandId = commandData['id'];
                var statut = commandData['statut'];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Commande ID: $commandId'),
                    subtitle: Text('Statut: $statut'),
                    // Ajoutez d'autres informations que vous souhaitez afficher
                    // à partir des données de la commande.
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
