import 'package:taskflow/core/consts/services.dart';
import 'package:taskflow/core/services/local_db.dart';

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();

  CurrentUser._internal();

  factory CurrentUser() => _instance;

  Map _details = {};

  Map get details => _details;

  Future<void> save(Map data) async {
    _details = data;
    await LocalDb().userBox.put('details', data);
  }

  Future<void> delete() async {
    _details.clear();
    await LocalDb().userBox.clear();
  }

  void init() {
    _details = LocalDb().userBox.get('details') ?? {};
    logger.d(_details);
  }
}
