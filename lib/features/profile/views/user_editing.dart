import 'package:flutter/material.dart';
import 'package:sanaa_artl/features/exhibitions/models/user.dart';
import 'package:sanaa_artl/features/profile/models/model_profile.dart';

class UserProvider1 extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  UserModel _user = UserModel(name: 'محمد أنور', imageUrl: null, id: '');

  UserModel get user => _user;

  void updateName(String newName) {
    _user = UserModel(
      name: newName,
      imageUrl: _user.imageUrl,
      id: _user.id,
      cvUrl: _user.cvUrl,
    );
    notifyListeners();
  }

  void updateImage(String newImageUrl) {
    _user = UserModel(
      name: _user.name,
      imageUrl: newImageUrl,
      id: _user.id,
      cvUrl: _user.cvUrl,
    );
    notifyListeners();
  }

  void updateCvUrl(String newCvUrl) {
    _user = UserModel(
      name: _user.name,
      imageUrl: _user.imageUrl,
      id: _user.id,
      cvUrl: newCvUrl,
    );
    notifyListeners();
  }
}
