import 'package:flutter/material.dart';

class LikeNotifier extends ChangeNotifier {
  bool _isLiked = false;
  int _likeAmount = 0;

  bool get isLiked => _isLiked;
  int get likeAmount => _likeAmount;

  void likeUp() {
    _likeAmount += 1;
  }

  void likeDown() {
    _likeAmount -= 1;
  }

  void toggleLike(bool isLiked) {
    _isLiked = isLiked;
    notifyListeners();
  }
}
