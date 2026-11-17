import 'package:taskflow/core/consts/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDb {
  static final LocalDb _instance = LocalDb._internal();

  LocalDb._internal();

  factory LocalDb() => _instance;

  Box? _userBox;
  Box? _appBox;

  Box get userBox => _userBox!;
  Box get appBox => _appBox!;

  Future<void> init() async {
    await Hive.initFlutter();

    final boxes = await Future.wait([
      Hive.openBox('User'),
      Hive.openBox('App'),
    ]);

    _userBox = boxes[0];
    _appBox = boxes[1];
  }

  Future<void> saveAppData(Object key, Object? data) async {
    try {
      await appBox.put(key, data);
      logger.d('Response stored in local DB at key $key');
    } catch (error) {
      logger.e('Error while storing local response', error: error);
    }
  }

  dynamic getAppData(Object key) {
    return appBox.get(key);
  }

  Map<String, dynamic> mapFromHive(dynamic value) {
    final converted = hiveValueToDart(value);
    if (converted is Map<String, dynamic>) return converted;
    if (converted is Map) return Map<String, dynamic>.from(converted);
    return {};
  }

  List<Map<String, dynamic>> mapListFromHive(dynamic value) {
    final converted = hiveValueToDart(value);
    if (converted is! List) return [];

    return converted.map(mapFromHive).toList();
  }

  dynamic mapOrListFromHive(dynamic value) {
    final converted = hiveValueToDart(value);

    if (converted is List) {
      return converted.map(mapFromHive).toList();
    }

    return mapFromHive(converted);
  }

  dynamic hiveValueToDart(dynamic value) {
    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(key.toString(), hiveValueToDart(item)),
      );
    }

    if (value is List) {
      return value.map(hiveValueToDart).toList();
    }

    return value;
  }
}
