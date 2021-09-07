import 'package:flutter/cupertino.dart';
import 'package:order_app/models/user_model.dart';
import 'package:order_app/api/firebase_api.dart';

class UserProvider extends ChangeNotifier{
      UserModel user = UserModel();

      void updateUser(UserModel updatedUser) {
            user.username = updatedUser.username;
            FirebaseApi.updateUserData(user);
            notifyListeners();
      }

      void getUserData(String id) {

      }
}
