import 'package:together/Model/UserModel.dart';

abstract class AuthInterface {
  String USER_NOT_FOUND;

  Future<UserModel> createUser(String email, String password);

  Future<UserModel> signIn(String email, String password);

  Future<String> getCurrentUserUid();

  Future<String> getOtherUser(String currentUser, List<String> allUsers);

  Future<bool> userIsLoggedIn();

  Future signOut();
}