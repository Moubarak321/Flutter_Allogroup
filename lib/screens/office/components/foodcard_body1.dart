import 'package:allogroup/screens/office/components/app_column.dart';
import 'package:allogroup/screens/office/widgets/big_text.dart';
import 'package:allogroup/screens/office/widgets/dimensions.dart';
import 'package:allogroup/screens/office/widgets/icon_and_text_widget.dart';
import 'package:allogroup/screens/office/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';

// import '../allofood/popular_food_details.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(
      viewportFraction:
          0.85); //gestion des marges au niveau du caroussel à droite et à gauche de sorte qu'on ait un aperçu du prochain er précédent slide
  var _currPageValue = 0.0; // pour le zoom in et out
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;
  List<String> articlesImages = [];

  Future<List<String>> getCaroussImages() async {
    List<String> images = [];
    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref("articles");
      final ListResult result = await storageReference.list();
      print(
          "============================== final2========================================");

      for (var item in result.items) {
        final String imageUrl = await item.getDownloadURL();
        images.add(imageUrl);
      }
      print(
          "===================================images added===================================");
    } catch (error) {
      print("Erreur lors de la récupération des images : $error");
    }
    print(images);
    print(
        "======================================================================");
    print(
        "======================================================================");
    print(
        "======================================================================");
    return images;
  }

  @override
  void initState() {
    super.initState();
    getCaroussImages().then((images) {
      setState(() {
        articlesImages = images;
        print(
            "===================================ooooooook===================================");
      });

    });
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
        // print("Current value is $_currPageValue");
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimensions.pageView,
          child: PageView.builder(
            controller: pageController,
            itemCount: 5,
            itemBuilder: (context, position) {
              return _buildPageItem(position);
              //nous retournons un widget créé un peu plus bas contenant tous les details du caroussel
            },
          ),
        ),

        ////============== caroussel dots //==============
        DotsIndicator(
          dotsCount: 5,
          position: _currPageValue,
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            // color: Colors.blue,
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            activeColor: Colors.orange,
          ),
        ),

        //============== Popular Text ==============
        //espace
        SizedBox(
          height: Dimensions.height30,
        ),

        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(
                text: "Popular",
                size: Dimensions.height20,
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: BigText(
                  text: ".",
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                child: SmallText(text: "Food pairing"),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            // Naviguer vers la nouvelle page lorsque l'élément est cliqué
            // Navigator.push(
              // context,
              // MaterialPageRoute(
                // builder: (context) {
                  // return PopularFoodDetail(); 
                  //// Remplacez DetailPage par votre propre page.
                // },
              // ),
            // );
          },
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: articlesImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom: Dimensions.height10),
                  child: Row(
                    children: [
                      // =============== image section ===============
                      Container(
                        width: Dimensions.listViewImgSize, //120
                        height: Dimensions.listViewImgSize, //120
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: Colors.white38,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                        articlesImages[index]),
                          ),
                        ),
                      ),

                      // =============== Text section ===============
                      Expanded(
                        child: Container(
                          height: Dimensions.listViewTextContSize, //100
                          // width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radius20),
                              bottomRight: Radius.circular(Dimensions.radius20),
                            ),
                            color: Colors.white,
                          ),

                          child: Padding(
                            padding: EdgeInsets.only(
                                left: Dimensions.width10,
                                right: Dimensions.width10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BigText(
                                  text: "Nutritious fruit meal in China",
                                ),
                                SizedBox(
                                  height: Dimensions.height10,
                                ),
                                SmallText(text: "With chinese characteristics"),
                                SizedBox(
                                  height: Dimensions.height10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // IconAndTextWidget(
                                    //     icon: Icons.circle_rounded,
                                    //     text: "Normal",
                                    //     iconColor: Colors.orange),
                                    IconAndTextWidget(
                                        icon: Icons.location_on,
                                        text: "1.7km",
                                        iconColor:
                                            Color.fromRGBO(10, 80, 137, 0.8)),
                                    IconAndTextWidget(
                                        icon: Icons.access_time_rounded,
                                        text: "32min",
                                        iconColor: Colors.red),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget _buildPageItem(int index) {
    Matrix4 matrix = Matrix4.identity(); //animation zoomin zoomout
    if (index == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == _currPageValue.floor() - 1) {
      // var currScale = _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            ////============== image container //==============
            height: Dimensions.pageViewContainer,
            margin: EdgeInsets.only(
                left: Dimensions.width10,
                right: Dimensions.width10), // marge légère entre les slides
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294CC),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/hamburger.jpg"),
              ),
            ),
          ),
          Align(
            //============== section tombante sous images du carouss ==============
            alignment: Alignment.bottomCenter,
            child: Container(
              // ============== conteneur blanc sous le carouss ==============
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.width30,
                  right: Dimensions.width30,
                  bottom: Dimensions.height30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
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
              ),

              child: Container(
                //============== section des textes ==============
                padding: EdgeInsets.only(
                    top: Dimensions.height10, left: 15, right: 15),
                child: AppColumn(
                  text: "Chinese Side",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



















// ===================================================statique=============================================

// import 'package:allogroup/screens/office/components/app_column.dart';
// import 'package:allogroup/screens/office/widgets/big_text.dart';
// import 'package:allogroup/screens/office/widgets/dimensions.dart';
// import 'package:allogroup/screens/office/widgets/icon_and_text_widget.dart';
// import 'package:allogroup/screens/office/widgets/small_text.dart';
// import 'package:flutter/material.dart';
// import 'package:dots_indicator/dots_indicator.dart';

// import '../allofood/popular_food_details.dart';

// class FoodPageBody extends StatefulWidget {
//   const FoodPageBody({super.key});

//   @override
//   State<FoodPageBody> createState() => _FoodPageBodyState();
// }

// class _FoodPageBodyState extends State<FoodPageBody> {
//   PageController pageController = PageController(
//       viewportFraction:
//           0.85); //gestion des marges au niveau du caroussel à droite et à gauche de sorte qu'on ait un aperçu du prochain er précédent slide
//   var _currPageValue = 0.0; // pour le zoom in et out
//   double _scaleFactor = 0.8;
//   double _height = Dimensions.pageViewContainer;

//   @override
//   void initState() {
//     super.initState();
//     pageController.addListener(() {
//       setState(() {
//         _currPageValue = pageController.page!;
//         // print("Current value is $_currPageValue");
//       });
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     pageController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: Dimensions.pageView,
//           child: PageView.builder(
//             controller: pageController,
//             itemCount: 5,
//             itemBuilder: (context, position) {
//               return _buildPageItem(position);
//               //nous retournons un widget créé un peu plus bas contenant tous les details du caroussel
//             },
//           ),
//         ),

//         ////============== caroussel dots //==============
//         DotsIndicator(
//           dotsCount: 5,
//           position: _currPageValue,
//           decorator: DotsDecorator(
//             size: const Size.square(9.0),
//             // color: Colors.blue,
//             activeSize: const Size(18.0, 9.0),
//             activeShape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5.0)),
//             activeColor: Colors.orange,
//           ),
//         ),

//         //============== Popular Text ==============
//         //espace
//         SizedBox(
//           height: Dimensions.height30,
//         ),

//         Container(
//           margin: EdgeInsets.only(left: Dimensions.width30),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               BigText(
//                 text: "Popular",
//                 size: Dimensions.height20,
//               ),
//               SizedBox(
//                 width: Dimensions.width10,
//               ),
//               Container(
//                 margin: const EdgeInsets.only(bottom: 4),
//                 child: BigText(
//                   text: ".",
//                   color: Colors.black26,
//                 ),
//               ),
//               SizedBox(
//                 width: Dimensions.width10,
//               ),
//               Container(
//                 margin: const EdgeInsets.only(bottom: 2),
//                 child: SmallText(text: "Food pairing"),
//               ),
//             ],
//           ),
//         ),

//         GestureDetector(
//           onTap: () {
//             // Naviguer vers la nouvelle page lorsque l'élément est cliqué
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) {
//                   return PopularFoodDetail(); // Remplacez DetailPage par votre propre page.
//                 },
//               ),
//             );
//           },
//           child: ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: 10,
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: EdgeInsets.only(
//                       left: Dimensions.width20,
//                       right: Dimensions.width20,
//                       bottom: Dimensions.height10),
//                   child: Row(
//                     children: [
//                       // =============== image section ===============
//                       Container(
//                         width: Dimensions.listViewImgSize, //120
//                         height: Dimensions.listViewImgSize, //120
//                         decoration: BoxDecoration(
//                           borderRadius:
//                               BorderRadius.circular(Dimensions.radius20),
//                           color: Colors.white38,
//                           image: DecorationImage(
//                             fit: BoxFit.cover,
//                             image: AssetImage("assets/images/pizza.jpg"),
//                           ),
//                         ),
//                       ),

//                       // =============== Text section ===============
//                       Expanded(
//                         child: Container(
//                           height: Dimensions.listViewTextContSize, //100
//                           // width: 200,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(Dimensions.radius20),
//                               bottomRight: Radius.circular(Dimensions.radius20),
//                             ),
//                             color: Colors.white,
//                           ),

//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: Dimensions.width10,
//                                 right: Dimensions.width10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 BigText(
//                                   text: "Nutritious fruit meal in China",
//                                 ),
//                                 SizedBox(
//                                   height: Dimensions.height10,
//                                 ),
//                                 SmallText(text: "With chinese characteristics"),
//                                 SizedBox(
//                                   height: Dimensions.height10,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     // IconAndTextWidget(
//                                     //     icon: Icons.circle_rounded,
//                                     //     text: "Normal",
//                                     //     iconColor: Colors.orange),
//                                     IconAndTextWidget(
//                                         icon: Icons.location_on,
//                                         text: "1.7km",
//                                         iconColor:
//                                             Color.fromRGBO(10, 80, 137, 0.8)),
//                                     IconAndTextWidget(
//                                         icon: Icons.access_time_rounded,
//                                         text: "32min",
//                                         iconColor: Colors.red),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//         ),
//       ],
//     );
//   }

//   Widget _buildPageItem(int index) {
//     Matrix4 matrix = Matrix4.identity(); //animation zoomin zoomout
//     if (index == _currPageValue.floor()) {
//       var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
//       var currTrans = _height * (1 - currScale) / 2;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, currTrans, 0);
//     } else if (index == _currPageValue.floor() + 1) {
//       var currScale =
//           _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
//       var currTrans = _height * (1 - currScale) / 2;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1);
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, currTrans, 0);
//     } else if (index == _currPageValue.floor() - 1) {
//       // var currScale = _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
//       var currScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
//       var currTrans = _height * (1 - currScale) / 2;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1);
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, currTrans, 0);
//     } else {
//       var currScale = 0.8;
//       matrix = Matrix4.diagonal3Values(1, currScale, 1)
//         ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
//     }

//     return Transform(
//       transform: matrix,
//       child: Stack(
//         children: [
//           Container(
//             ////============== image container //==============
//             height: Dimensions.pageViewContainer,
//             margin: EdgeInsets.only(
//                 left: Dimensions.width10,
//                 right: Dimensions.width10), // marge légère entre les slides
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(Dimensions.radius30),
//               color: index.isEven ? Color(0xFF69c5df) : Color(0xFF9294CC),
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: AssetImage("assets/images/hamburger.jpg"),
//               ),
//             ),
//           ),
//           Align(
//             //============== section tombante sous images du carouss ==============
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               // ============== conteneur blanc sous le carouss ==============
//               height: Dimensions.pageViewTextContainer,
//               margin: EdgeInsets.only(
//                   left: Dimensions.width30,
//                   right: Dimensions.width30,
//                   bottom: Dimensions.height30),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(Dimensions.radius20),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color(0xFFe8e8e8),
//                     blurRadius: 5.0,
//                     offset: Offset(0, 5),
//                   ),
//                   BoxShadow(
//                     color: Colors.white,
//                     offset: Offset(-5, 0),
//                   ),
//                   BoxShadow(
//                     color: Colors.white,
//                     offset: Offset(5, 0),
//                   ),
//                 ],
//               ),

//               child: Container(
//                 //============== section des textes ==============
//                 padding: EdgeInsets.only(
//                     top: Dimensions.height10, left: 15, right: 15),
//                 child: AppColumn(
//                   text: "Chinese Side",
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
