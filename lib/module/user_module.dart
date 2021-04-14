
import 'package:greca/models/User.dart';

class UserModule {
  static User user;

  static void createUser(dynamic json) {
    user = User.fromJson(json);
  }
}