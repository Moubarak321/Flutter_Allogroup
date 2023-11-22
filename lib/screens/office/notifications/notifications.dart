import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Notifications extends StatelessWidget {
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }


 Widget buildCourseCard(Map<String, dynamic> courseData) {
  initializeDateFormatting('fr_FR', null);

  final date = courseData['date'] != null ? DateTime.fromMillisecondsSinceEpoch(courseData['date']) : null;
  final titre = courseData['title'];
  final image = courseData['image'];

  return Container(
    width: double.infinity,
    margin: EdgeInsets.all(8.0),
    padding: EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color(0xFFe8e8e8),
          blurRadius: 5.0,
          offset: Offset(0, 5),
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(-5, 0),
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(5, 0),
        ),
      ],
      color: Colors.orange,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Affichage du titre
        Text(
          titre ?? "",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        // Affichage de l'image
        if (image != null && image.isNotEmpty)
          Image.network(
            image,
            width: double.infinity,
            height: 300, 
            fit: BoxFit.cover,
          ),
        SizedBox(height: 10),
       
        
        // Affichage de la date
        if (date != null)
          Text(
            DateFormat.yMMMMEEEEd('fr_FR').format(date),
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
        SizedBox(height: 10),
      ],
    ),
  );
}

Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                right: Dimensions.width20, left: Dimensions.width20),
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue, // Couleur d'arrière-plan en bleu
              ),
              child: Center(
                child: Text(
                  'Quoi de neuf ?',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white, // Couleur du texte en blanc
                  ),
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('administrateur')
                  .doc('admin') 
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return Center(
                    child: Text(
                      "Aucune donnée disponible",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;

                if (!userData.containsKey('promotion')) {
                  return Center(
                    child: Text(
                      "Aucune promotion disponible",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  );
                }

                final courses = userData['promotion'] as List<dynamic>;

                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final courseData = courses[index] as Map<String, dynamic>;
                    return buildCourseCard(courseData);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
