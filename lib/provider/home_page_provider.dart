import 'package:flutter/foundation.dart';
import 'package:mil/models/user_info.dart';

class HomePageProvider extends ChangeNotifier {
  bool _isHomePageProcessing = true;
  int _currentPage = 1;
  List<UserInfo> _postsList = [];
  bool _shouldRefresh = true;

  bool get shouldRefresh => _shouldRefresh;

  setShouldRefresh(bool value) => _shouldRefresh = value;

  int get currentPage => _currentPage;

  setCurrentPage(int page) {
    _currentPage = page;
  }

  bool get isHomePageProcessing => _isHomePageProcessing;

  setIsHomePageProcessing(bool value) {
    _isHomePageProcessing = value;
    notifyListeners();
  }

  List<UserInfo> get postsList => _postsList;

  setPostsList(List<UserInfo> list, {bool notify = true}) {
    _postsList = list;
    if (notify) notifyListeners();
  }

  mergePostsList(List<UserInfo> list, {bool notify = true}) {
    _postsList.addAll(list);
    if (notify) notifyListeners();
  }

  addPost(UserInfo post, {bool notify = true}) {
    _postsList.add(post);
    if (notify) notifyListeners();
  }

  UserInfo getPostByIndex(int index) => _postsList[index];

  int get postsListLength => _postsList.length;
}