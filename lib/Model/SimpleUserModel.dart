import 'package:together/Model/UserModel.dart';

class SimpleUser extends UserModel {
  String cardNumber;

  SimpleUser(String email, String uid) : super(email, uid);

  void setCardNumber(String cardNumber) {
    this.cardNumber = cardNumber;
  }
}