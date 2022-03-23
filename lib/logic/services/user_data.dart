import 'package:get_storage/get_storage.dart';

import '../models/user.dart';

class UserData {
  final GetStorage _storage = GetStorage();
  final nameKey = 'nameKey';
  final picKey = 'picKey';

  saveData(User user) {
    _storage.write(nameKey, user.userName);
    _storage.write(picKey, user.profilePic);
  }

  User loadUser() {
    User user = User(
        userName: _storage.read<String>(nameKey) ?? 'Default User',
        profilePic: _storage.read<int>(picKey) ?? 0);
    return user;
  }

  void resetData() {
    _storage.remove(nameKey);
    _storage.remove(picKey);
  }
}
