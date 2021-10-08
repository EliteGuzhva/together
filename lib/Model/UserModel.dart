abstract class UserModel {
  String email;
  String uid;

  UserModel(this.email, this.uid);

  void defaultInitialization(String email, String uid) {
    this.email = email;
    this.uid = uid;
  }
}