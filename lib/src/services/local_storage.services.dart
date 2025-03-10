import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();

  factory LocalStorage() {
    return _instance;
  }
  LocalStorage._internal();

  late Box _userBox;

  Future<void> init() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    _userBox = await Hive.openBox('userBox');
  }

  Future<void> clear() async {
    await _userBox.clear();
  }

  Future<void> saveUserData(String usernameOrEmail, String password) async {
    await _userBox.put('usernameOrEmail', usernameOrEmail);
    await _userBox.put('password', password);
  }

  Future<dynamic> getUserData(String usernameOrEmail) async {
    final String password =
        _userBox.get('password', defaultValue: '') as String;

    return {
      'usernameOrEmail': usernameOrEmail,
      'password': password,
    };
  }

  String getEmailOrUser() {
    return _userBox.get('usernameOrEmail', defaultValue: '') as String;
  }

  String getPassword() {
    return _userBox.get('password', defaultValue: '') as String;
  }

  Future<void> setIsSignedIn(bool isSignedIn) async {
    await _userBox.put('is_signedin', isSignedIn);
  }

  bool getIsSignedIn() {
    return _userBox.get('is_signedin', defaultValue: false) as bool;
  }

  Future<void> deleteIsSignedIn() async {
    await _userBox.delete('is_signedin');
  }

  Future<void> setIsLoggedIn(bool isLoggedIn) async {
    await _userBox.put('is_loggedIn', isLoggedIn);
  }

  bool getIsLoggedIn() {
    return _userBox.get('is_loggedIn', defaultValue: false) as bool;
  }

  Future<dynamic> getIsFirstTime() async {
    final bool isFirstTime =
        _userBox.get('isFirstTime', defaultValue: true) as bool;

    if (isFirstTime) {
      await _userBox.put('isFirstTime', false);
      return true;
    }
    return false;
  }

  Future<void> savePageIndex(int index) async {
    await _userBox.put('pageIndex', index);
  }

  int getPageIndex() {
    return _userBox.get('pageIndex', defaultValue: 0) as int;
  }
}
