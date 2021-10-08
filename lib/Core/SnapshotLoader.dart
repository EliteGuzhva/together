import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:together/Core/Logger.dart';

abstract class SnapshotLoader {
  var _isLoadingStreamController = BehaviorSubject<bool>();
  Stream<bool> get isLoading => _isLoadingStreamController.stream;

  void loadData(AsyncSnapshot<dynamic> snapshot) {
    if (!snapshot.hasData) {
      logDebug(this.toString(), "no data");
      _isLoadingStreamController.sink.add(true);
    } else {
      if (snapshot.hasError) {
        _isLoadingStreamController.sink.add(true);
        logError(this.toString(), snapshot.error.toString());
      } else {
        _isLoadingStreamController.sink.add(false);
        onDidLoad(snapshot);
      }
    }
  }

  void onDidLoad(AsyncSnapshot<dynamic> snapshot);

  void dispose() {
    _isLoadingStreamController.close();
  }
}