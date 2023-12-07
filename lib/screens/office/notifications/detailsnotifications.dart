import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
class Detailsnotifications extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final int index;

  Detailsnotifications({required this.courseData, required this.index});
  
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR', null);

    final date = courseData['date'] != null ? DateTime.fromMillisecondsSinceEpoch(courseData['date']) : null;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text('Que disent-ils ?',
            style: TextStyle(color: Colors.white, fontSize: Dimensions.height20)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 75,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Revenir à la page précédente
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xCC0A5089),
                    ),
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xCC0A5089),
                  ),
                  child: Icon(
                    Icons.add_shopping_cart_outlined,
                    color: Colors.white,
                  ), 
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                DateFormat.yMMMMEEEEd('fr_FR').format(date!),
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
                  
                ),
              ),
            ),
            pinned: true,
            backgroundColor: Color.fromRGBO(10, 80, 137, 1),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                courseData["image"],
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    courseData['content'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Ajoute ici la liste de produits si nécessaire (buildProductList())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
