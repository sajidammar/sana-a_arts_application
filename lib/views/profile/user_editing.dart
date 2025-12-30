import 'package:flutter/material.dart';
import 'package:sanaa_artl/models/exhibition/user.dart';
import 'package:sanaa_artl/views/profile/model_profile.dart';

class UserProvider1 extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  UserModel _user = UserModel(
    name: 'محمد أنور',
    imageUrl: null,
    id: '',

  );

  UserModel get user => _user;

  void updateName(String newName) {
    _user = UserModel(
      name: newName,
      imageUrl: _user.imageUrl,
      id: _user.id,
    );
    notifyListeners();
  }

  void updateImage(String newImageUrl) {
    _user = UserModel(
      name: _user.name,
      imageUrl: newImageUrl,
      id: _user.id,
    );
    notifyListeners();
  }
}
