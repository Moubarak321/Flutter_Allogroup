import 'package:allogroup/screens/office/widgets/app_icon.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/expandable_text_widget.dart';
import 'package:flutter/material.dart';

class RecommendedFoodDetail extends StatelessWidget {
  const RecommendedFoodDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  child: AppIcon(icon: Icons.clear, backgroundColor:Color(0xCC0A5089) , iconColor: Colors.white, )
                ),
                AppIcon(icon: Icons.add_shopping_cart_outlined, backgroundColor:Color(0xCC0A5089), iconColor: Colors.white),
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
                    topLeft: Radius.circular(Dimensions.radius20),
                    topRight: Radius.circular(Dimensions.radius20)
                  )
                ),
                child: Center(
                    child: BigText(
                  text: "Ci Gustaa",
                  size: Dimensions.font26,
                )),
              ),
            ),
            pinned: true,
            backgroundColor: Color.fromRGBO(10, 80, 137, 1),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/pizza.jpg",
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                  child: ExpandableTextWidget(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam vestibulum lorem ac rhoncus pretium. Cras diam dolor, convallis quis ultrices eu, tempus et tortor. Morbi dolor diam, tincidunt eget aliquet id, faucibus ac massa. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aliquam sagittis laoreet lacus, non tincidunt nulla iaculis nec. Cras ac dui eu felis ornare congue nec at massa. Nam a elit vel elit feugiat molestie.Nulla nulla justo, tristique eu placerat id, fermentum ac lacus. Integer nec mauris lacinia, maximus nisl sit amet, accumsan metus. Aenean justo eros, molestie ut felis sit amet, varius porttitor mauris. In rhoncus, libero et condimentum cursus, magna augue tempor eros, at condimentum nisl mauris non libero. Donec sollicitudin feugiat posuere. Nam elit nulla, malesuada vitae porta sit amet, molestie ut mi. Quisque quis erat lobortis risus fringilla volutpat tincidunt et elit. Fusce imperdiet vitae ante ut elementum.Phasellus eget pharetra mauris. Maecenas dignissim aliquet interdum. Donec vulputate mi sed bibendum lacinia. Morbi dignissim arcu id sapien sagittis rutrum. Morbi eu metus purus. Maecenas tristique nisl et enim varius, non aliquam orci ultrices. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae Nam mattis, ligula et aliquet pharetra, velit tortor iaculis arcu, vel eleifend erat enim ut est. Quisque sit amet elit augue. Sed accumsan magna eu mi condimentum congue. Morbi dignissim elit erat. Cras quis feugiat ex, commodo aliquam nisl. Fusce varius, purus at convallis suscipit, nisi tellus tincidunt justo, ut pellentesque metus orci quis nisi. Donec laoreet odio massa, et pulvinar nunc vulputate vitae. Aliquam et justo nunc.Praesent elit turpis, tristique at volutpat sed, tempus nec tortor. Nullam tincidunt nisi vestibulum ipsum varius, sit amet tristique ante efficitur. Mauris diam enim, euismod et dolor sit amet, malesuada elementum metus. Maecenas risus ipsum, eleifend ac posuere porta, varius et tellus. Morbi congue dolor interdum augue convallis commodo. Praesent vitae aliquam ipsum. Praesent in erat mattis elit condimentum ultrices at a felis. Proin efficitur commodo dui, ut vestibulum nisl interdum sed. Duis et finibus mauris, eget rhoncus lectus. Nunc luctus dolor id orci mollis, id iaculis arcu ultricies. Nunc massa magna, efficitur et sodales aliquet, tempor vitae ante. Fusce feugiat placerat blandit. Vivamus quis feugiat elit. Donec a felis id tortor molestie suscipit sollicitudin vel felis. Morbi et venenatis sem, et cursus sapien. Donec ullamcorper ultrices libero, in rutrum nibh aliquet nec.",),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
