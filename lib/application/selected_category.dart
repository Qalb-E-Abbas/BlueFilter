import 'package:flutter/cupertino.dart';

class SelectedCategory extends ChangeNotifier {
  List<String> _list = [];

  void addItem(String id) {
    _list.add(id);
    notifyListeners();
  }

  void removeItem(String id) {
    _list.remove(id);
    notifyListeners();
  }

  void clearList() {
    _list.clear();
    notifyListeners();
  }

  List<String> getCategoryList() => _list;
}
