import 'package:get/get.dart';

class QuantityController extends GetxController {
  var quantity = 0.obs;

  void setQuantity(int newQuantity) {
    quantity.value = newQuantity;
  }
}
