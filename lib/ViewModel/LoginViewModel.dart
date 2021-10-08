import 'package:rxdart/rxdart.dart';

import 'package:together/Core/Logger.dart';
import 'package:together/Server/Server.dart';


class LoginViewModel {
  final _server = Server.instance;

  String background = "assets/loginBackground.png";
  String logo = "assets/loginLogo.png";

  var _isCheckingStreamController = BehaviorSubject<bool>();
  var _emailStreamController = BehaviorSubject<String>();
  var _passwordStreamController = BehaviorSubject<String>();

  Stream<bool> get isChecking => _isCheckingStreamController.stream;
  Function(String) get emailChanged => _emailStreamController.sink.add;
  Function(String) get passwordChanged => _passwordStreamController.sink.add;

  void init(Function onDidInit) {
    onDidInit();
  }

  void signIn(Function onSuccess) {
    _isCheckingStreamController.sink.add(true);

    String email = _emailStreamController.stream.value;
    String password = _passwordStreamController.stream.value;

    _server.auth.signIn(email, password).then((user) {
      _server.backend.saveDeviceToken();
      doOnSuccess();
      onSuccess();
    }).catchError((e) {
      logError(mainLog, e.toString());
      _isCheckingStreamController.sink.add(false);
    });
  }

  void userLoggedIn(Function onSuccess) async {
    _isCheckingStreamController.sink.add(true);

    final isLoggedIn = await _server.auth.userIsLoggedIn();

    if (isLoggedIn) {
      doOnSuccess();
      onSuccess();
      return;
    }

    _isCheckingStreamController.sink.add(false);
  }

  void doOnSuccess() async {
    _server.database.getMessages();
  }

  void dispose() {
    _isCheckingStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
  }
}
