// import 'package:allogroup/screens/office/components/foodcard_body.dart';
import 'package:allogroup/screens/office/allofood/cart.dart';
import 'package:flutter/material.dart';
// import 'foodcard_body.dart'

class CustomSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      title: const Text("Allô Group"),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          onPressed: () {
             
                     Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Cart();
                    },
                  ),
                );
                 
          },
          icon: const Icon(Icons.shopping_cart),
        ),
      ],
    );
}
}
